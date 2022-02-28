// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;

#using_animtree("generic");
#using_animtree("all_player");

#namespace util;

/*
	Name: empty
	Namespace: util
	Checksum: 0xF567718D
	Offset: 0xA98
	Size: 0x2C
	Parameters: 5
	Flags: Linked
*/
function empty(a, b, c, d, e)
{
}

/*
	Name: wait_network_frame
	Namespace: util
	Checksum: 0xC5E03B92
	Offset: 0xAD0
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function wait_network_frame(n_count = 1)
{
	if(numremoteclients())
	{
		for(i = 0; i < n_count; i++)
		{
			snapshot_ids = getsnapshotindexarray();
			acked = undefined;
			while(!isdefined(acked))
			{
				level waittill(#"snapacknowledged");
				acked = snapshotacknowledged(snapshot_ids);
			}
		}
	}
	else
	{
		wait(0.1 * n_count);
	}
}

/*
	Name: streamer_wait
	Namespace: util
	Checksum: 0xED6E48D2
	Offset: 0xBB0
	Size: 0x2A0
	Parameters: 4
	Flags: Linked
*/
function streamer_wait(n_stream_request_id, n_wait_frames = 0, n_timeout = 0, b_bonuszm_streamer_fallback = 1)
{
	level endon(#"loading_movie_done");
	if(n_wait_frames > 0)
	{
		wait_network_frame(n_wait_frames);
	}
	if(sessionmodeiscampaignzombiesgame() && (isdefined(b_bonuszm_streamer_fallback) && b_bonuszm_streamer_fallback))
	{
		if(!n_timeout)
		{
			n_timeout = 7;
		}
	}
	timeout = gettime() + (n_timeout * 1000);
	if(self == level)
	{
		n_num_streamers_ready = 0;
		do
		{
			wait_network_frame();
			n_num_streamers_ready = 0;
			foreach(player in getplayers())
			{
				if((isdefined(n_stream_request_id) ? player isstreamerready(n_stream_request_id) : player isstreamerready()))
				{
					n_num_streamers_ready++;
				}
			}
			if(n_timeout > 0 && gettime() > timeout)
			{
				break;
			}
		}
		while(n_num_streamers_ready < max(1, getplayers().size));
	}
	else
	{
		self endon(#"disconnect");
		do
		{
			wait_network_frame();
			if(n_timeout > 0 && gettime() > timeout)
			{
				break;
			}
		}
		while(!(isdefined(n_stream_request_id) ? self isstreamerready(n_stream_request_id) : self isstreamerready()));
	}
}

/*
	Name: draw_debug_line
	Namespace: util
	Checksum: 0x899EDFFB
	Offset: 0xE58
	Size: 0x86
	Parameters: 3
	Flags: Linked
*/
function draw_debug_line(start, end, timer)
{
	/#
		for(i = 0; i < (timer * 20); i++)
		{
			line(start, end, (1, 1, 0.5));
			wait(0.05);
		}
	#/
}

/*
	Name: debug_line
	Namespace: util
	Checksum: 0xAA6A427E
	Offset: 0xEE8
	Size: 0xB4
	Parameters: 6
	Flags: Linked
*/
function debug_line(start, end, color, alpha, depthtest, duration)
{
	/#
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		if(!isdefined(alpha))
		{
			alpha = 1;
		}
		if(!isdefined(depthtest))
		{
			depthtest = 0;
		}
		if(!isdefined(duration))
		{
			duration = 100;
		}
		line(start, end, color, alpha, depthtest, duration);
	#/
}

/*
	Name: debug_spherical_cone
	Namespace: util
	Checksum: 0x20251A7A
	Offset: 0xFA8
	Size: 0xDC
	Parameters: 8
	Flags: None
*/
function debug_spherical_cone(origin, domeapex, angle, slices, color, alpha, depthtest, duration)
{
	/#
		if(!isdefined(slices))
		{
			slices = 10;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		if(!isdefined(alpha))
		{
			alpha = 1;
		}
		if(!isdefined(depthtest))
		{
			depthtest = 0;
		}
		if(!isdefined(duration))
		{
			duration = 100;
		}
		sphericalcone(origin, domeapex, angle, slices, color, alpha, depthtest, duration);
	#/
}

/*
	Name: debug_sphere
	Namespace: util
	Checksum: 0xB68F69B4
	Offset: 0x1090
	Size: 0xCC
	Parameters: 5
	Flags: Linked
*/
function debug_sphere(origin, radius, color, alpha, time)
{
	/#
		if(!isdefined(time))
		{
			time = 1000;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		sides = int(10 * (1 + (int(radius) % 100)));
		sphere(origin, radius, color, alpha, 1, sides, time);
	#/
}

/*
	Name: waittillend
	Namespace: util
	Checksum: 0x160F1E6A
	Offset: 0x1168
	Size: 0x1E
	Parameters: 1
	Flags: None
*/
function waittillend(msg)
{
	self waittillmatch(msg);
}

/*
	Name: track
	Namespace: util
	Checksum: 0xBB916E55
	Offset: 0x1190
	Size: 0x38
	Parameters: 1
	Flags: None
*/
function track(spot_to_track)
{
	if(isdefined(self.current_target))
	{
		if(spot_to_track == self.current_target)
		{
			return;
		}
	}
	self.current_target = spot_to_track;
}

/*
	Name: waittill_string
	Namespace: util
	Checksum: 0x7277804F
	Offset: 0x11D0
	Size: 0x58
	Parameters: 2
	Flags: Linked
*/
function waittill_string(msg, ent)
{
	if(msg != "death")
	{
		self endon(#"death");
	}
	ent endon(#"die");
	self waittill(msg);
	ent notify(#"returned", msg);
}

/*
	Name: waittill_level_string
	Namespace: util
	Checksum: 0x502FF31F
	Offset: 0x1230
	Size: 0x50
	Parameters: 3
	Flags: Linked
*/
function waittill_level_string(msg, ent, otherent)
{
	otherent endon(#"death");
	ent endon(#"die");
	level waittill(msg);
	ent notify(#"returned", msg);
}

/*
	Name: waittill_multiple
	Namespace: util
	Checksum: 0xF39C1963
	Offset: 0x1288
	Size: 0xAA
	Parameters: 1
	Flags: Linked, Variadic
*/
function waittill_multiple(...)
{
	s_tracker = spawnstruct();
	s_tracker._wait_count = 0;
	for(i = 0; i < vararg.size; i++)
	{
		self thread _waitlogic(s_tracker, vararg[i]);
	}
	if(s_tracker._wait_count > 0)
	{
		s_tracker waittill(#"waitlogic_finished");
	}
}

/*
	Name: waittill_either
	Namespace: util
	Checksum: 0xFAF43561
	Offset: 0x1340
	Size: 0x26
	Parameters: 2
	Flags: Linked
*/
function waittill_either(msg1, msg2)
{
	self endon(msg1);
	self waittill(msg2);
}

/*
	Name: break_glass
	Namespace: util
	Checksum: 0x73F9F2B4
	Offset: 0x1370
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function break_glass(n_radius = 50)
{
	n_radius = float(n_radius);
	if(n_radius == -1)
	{
		v_origin_offset = (0, 0, 0);
		n_radius = 100;
	}
	else
	{
		v_origin_offset = vectorscale((0, 0, 1), 40);
	}
	glassradiusdamage(self.origin + v_origin_offset, n_radius, 500, 500);
}

/*
	Name: waittill_multiple_ents
	Namespace: util
	Checksum: 0xC4C8467
	Offset: 0x1430
	Size: 0x1E2
	Parameters: 1
	Flags: Variadic
*/
function waittill_multiple_ents(...)
{
	a_ents = [];
	a_notifies = [];
	for(i = 0; i < vararg.size; i++)
	{
		if(i % 2)
		{
			if(!isdefined(a_notifies))
			{
				a_notifies = [];
			}
			else if(!isarray(a_notifies))
			{
				a_notifies = array(a_notifies);
			}
			a_notifies[a_notifies.size] = vararg[i];
			continue;
		}
		if(!isdefined(a_ents))
		{
			a_ents = [];
		}
		else if(!isarray(a_ents))
		{
			a_ents = array(a_ents);
		}
		a_ents[a_ents.size] = vararg[i];
	}
	s_tracker = spawnstruct();
	s_tracker._wait_count = 0;
	for(i = 0; i < a_ents.size; i++)
	{
		ent = a_ents[i];
		if(isdefined(ent))
		{
			ent thread _waitlogic(s_tracker, a_notifies[i]);
		}
	}
	if(s_tracker._wait_count > 0)
	{
		s_tracker waittill(#"waitlogic_finished");
	}
}

/*
	Name: _waitlogic
	Namespace: util
	Checksum: 0xC3A6C319
	Offset: 0x1620
	Size: 0xD0
	Parameters: 2
	Flags: Linked
*/
function _waitlogic(s_tracker, notifies)
{
	s_tracker._wait_count++;
	if(!isdefined(notifies))
	{
		notifies = [];
	}
	else if(!isarray(notifies))
	{
		notifies = array(notifies);
	}
	notifies[notifies.size] = "death";
	waittill_any_array(notifies);
	s_tracker._wait_count--;
	if(s_tracker._wait_count == 0)
	{
		s_tracker notify(#"waitlogic_finished");
	}
}

/*
	Name: waittill_any_return
	Namespace: util
	Checksum: 0x8440F153
	Offset: 0x16F8
	Size: 0x268
	Parameters: 7
	Flags: Linked
*/
function waittill_any_return(string1, string2, string3, string4, string5, string6, string7)
{
	if(!isdefined(string1) || string1 != "death" && (!isdefined(string2) || string2 != "death") && (!isdefined(string3) || string3 != "death") && (!isdefined(string4) || string4 != "death") && (!isdefined(string5) || string5 != "death") && (!isdefined(string6) || string6 != "death") && (!isdefined(string7) || string7 != "death"))
	{
		self endon(#"death");
	}
	ent = spawnstruct();
	if(isdefined(string1))
	{
		self thread waittill_string(string1, ent);
	}
	if(isdefined(string2))
	{
		self thread waittill_string(string2, ent);
	}
	if(isdefined(string3))
	{
		self thread waittill_string(string3, ent);
	}
	if(isdefined(string4))
	{
		self thread waittill_string(string4, ent);
	}
	if(isdefined(string5))
	{
		self thread waittill_string(string5, ent);
	}
	if(isdefined(string6))
	{
		self thread waittill_string(string6, ent);
	}
	if(isdefined(string7))
	{
		self thread waittill_string(string7, ent);
	}
	ent waittill(#"returned", msg);
	ent notify(#"die");
	return msg;
}

/*
	Name: waittill_any_ex
	Namespace: util
	Checksum: 0x4C6EF606
	Offset: 0x1968
	Size: 0x1CC
	Parameters: 1
	Flags: Linked, Variadic
*/
function waittill_any_ex(...)
{
	s_common = spawnstruct();
	e_current = self;
	n_arg_index = 0;
	if(strisnumber(vararg[0]))
	{
		n_timeout = vararg[0];
		n_arg_index++;
		if(n_timeout > 0)
		{
			s_common thread _timeout(n_timeout);
		}
	}
	if(isarray(vararg[n_arg_index]))
	{
		a_params = vararg[n_arg_index];
		n_start_index = 0;
	}
	else
	{
		a_params = vararg;
		n_start_index = n_arg_index;
	}
	for(i = n_start_index; i < a_params.size; i++)
	{
		if(!isstring(a_params[i]))
		{
			e_current = a_params[i];
			continue;
		}
		if(isdefined(e_current))
		{
			e_current thread waittill_string(a_params[i], s_common);
		}
	}
	s_common waittill(#"returned", str_notify);
	s_common notify(#"die");
	return str_notify;
}

/*
	Name: waittill_any_array_return
	Namespace: util
	Checksum: 0x49BA8C12
	Offset: 0x1B40
	Size: 0x118
	Parameters: 1
	Flags: None
*/
function waittill_any_array_return(a_notifies)
{
	if(isinarray(a_notifies, "death"))
	{
		self endon(#"death");
	}
	s_tracker = spawnstruct();
	foreach(str_notify in a_notifies)
	{
		if(isdefined(str_notify))
		{
			self thread waittill_string(str_notify, s_tracker);
		}
	}
	s_tracker waittill(#"returned", msg);
	s_tracker notify(#"die");
	return msg;
}

/*
	Name: waittill_any
	Namespace: util
	Checksum: 0x85988244
	Offset: 0x1C60
	Size: 0x94
	Parameters: 6
	Flags: Linked
*/
function waittill_any(str_notify1, str_notify2, str_notify3, str_notify4, str_notify5, str_notify6)
{
	/#
		assert(isdefined(str_notify1));
	#/
	waittill_any_array(array(str_notify1, str_notify2, str_notify3, str_notify4, str_notify5, str_notify6));
}

/*
	Name: waittill_any_array
	Namespace: util
	Checksum: 0xFE9828CE
	Offset: 0x1D00
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function waittill_any_array(a_notifies)
{
	if(!isdefined(a_notifies))
	{
		a_notifies = [];
	}
	else if(!isarray(a_notifies))
	{
		a_notifies = array(a_notifies);
	}
	/#
		assert(isdefined(a_notifies[0]), "");
	#/
	for(i = 1; i < a_notifies.size; i++)
	{
		if(isdefined(a_notifies[i]))
		{
			self endon(a_notifies[i]);
		}
	}
	self waittill(a_notifies[0]);
}

/*
	Name: waittill_any_timeout
	Namespace: util
	Checksum: 0x878D6DF4
	Offset: 0x1DE8
	Size: 0x1F0
	Parameters: 6
	Flags: Linked
*/
function waittill_any_timeout(n_timeout, string1, string2, string3, string4, string5)
{
	if(!isdefined(string1) || string1 != "death" && (!isdefined(string2) || string2 != "death") && (!isdefined(string3) || string3 != "death") && (!isdefined(string4) || string4 != "death") && (!isdefined(string5) || string5 != "death"))
	{
		self endon(#"death");
	}
	ent = spawnstruct();
	if(isdefined(string1))
	{
		self thread waittill_string(string1, ent);
	}
	if(isdefined(string2))
	{
		self thread waittill_string(string2, ent);
	}
	if(isdefined(string3))
	{
		self thread waittill_string(string3, ent);
	}
	if(isdefined(string4))
	{
		self thread waittill_string(string4, ent);
	}
	if(isdefined(string5))
	{
		self thread waittill_string(string5, ent);
	}
	ent thread _timeout(n_timeout);
	ent waittill(#"returned", msg);
	ent notify(#"die");
	return msg;
}

/*
	Name: waittill_level_any_timeout
	Namespace: util
	Checksum: 0x937EAAFF
	Offset: 0x1FE0
	Size: 0x1A0
	Parameters: 7
	Flags: Linked
*/
function waittill_level_any_timeout(n_timeout, otherent, string1, string2, string3, string4, string5)
{
	otherent endon(#"death");
	ent = spawnstruct();
	if(isdefined(string1))
	{
		level thread waittill_level_string(string1, ent, otherent);
	}
	if(isdefined(string2))
	{
		level thread waittill_level_string(string2, ent, otherent);
	}
	if(isdefined(string3))
	{
		level thread waittill_level_string(string3, ent, otherent);
	}
	if(isdefined(string4))
	{
		level thread waittill_level_string(string4, ent, otherent);
	}
	if(isdefined(string5))
	{
		level thread waittill_level_string(string5, ent, otherent);
	}
	if(isdefined(otherent))
	{
		otherent thread waittill_string("death", ent);
	}
	ent thread _timeout(n_timeout);
	ent waittill(#"returned", msg);
	ent notify(#"die");
	return msg;
}

/*
	Name: _timeout
	Namespace: util
	Checksum: 0x930B4D6D
	Offset: 0x2188
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function _timeout(delay)
{
	self endon(#"die");
	wait(delay);
	self notify(#"returned", "timeout");
}

/*
	Name: waittill_any_ents
	Namespace: util
	Checksum: 0x6FEEBC0E
	Offset: 0x21C8
	Size: 0x174
	Parameters: 14
	Flags: Linked
*/
function waittill_any_ents(ent1, string1, ent2, string2, ent3, string3, ent4, string4, ent5, string5, ent6, string6, ent7, string7)
{
	/#
		assert(isdefined(ent1));
	#/
	/#
		assert(isdefined(string1));
	#/
	if(isdefined(ent2) && isdefined(string2))
	{
		ent2 endon(string2);
	}
	if(isdefined(ent3) && isdefined(string3))
	{
		ent3 endon(string3);
	}
	if(isdefined(ent4) && isdefined(string4))
	{
		ent4 endon(string4);
	}
	if(isdefined(ent5) && isdefined(string5))
	{
		ent5 endon(string5);
	}
	if(isdefined(ent6) && isdefined(string6))
	{
		ent6 endon(string6);
	}
	if(isdefined(ent7) && isdefined(string7))
	{
		ent7 endon(string7);
	}
	ent1 waittill(string1);
}

/*
	Name: waittill_any_ents_two
	Namespace: util
	Checksum: 0xC5D3EE7E
	Offset: 0x2348
	Size: 0x8E
	Parameters: 4
	Flags: Linked
*/
function waittill_any_ents_two(ent1, string1, ent2, string2)
{
	/#
		assert(isdefined(ent1));
	#/
	/#
		assert(isdefined(string1));
	#/
	if(isdefined(ent2) && isdefined(string2))
	{
		ent2 endon(string2);
	}
	ent1 waittill(string1);
}

/*
	Name: isflashed
	Namespace: util
	Checksum: 0x2EBC088D
	Offset: 0x23E0
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function isflashed()
{
	if(!isdefined(self.flashendtime))
	{
		return 0;
	}
	return gettime() < self.flashendtime;
}

/*
	Name: isstunned
	Namespace: util
	Checksum: 0x384A53E0
	Offset: 0x2408
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function isstunned()
{
	if(!isdefined(self.flashendtime))
	{
		return 0;
	}
	return gettime() < self.flashendtime;
}

/*
	Name: single_func
	Namespace: util
	Checksum: 0xB717BCD5
	Offset: 0x2430
	Size: 0x16C
	Parameters: 8
	Flags: Linked
*/
function single_func(entity = level, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	if(isdefined(arg6))
	{
		return entity [[func]](arg1, arg2, arg3, arg4, arg5, arg6);
	}
	if(isdefined(arg5))
	{
		return entity [[func]](arg1, arg2, arg3, arg4, arg5);
	}
	if(isdefined(arg4))
	{
		return entity [[func]](arg1, arg2, arg3, arg4);
	}
	if(isdefined(arg3))
	{
		return entity [[func]](arg1, arg2, arg3);
	}
	if(isdefined(arg2))
	{
		return entity [[func]](arg1, arg2);
	}
	if(isdefined(arg1))
	{
		return entity [[func]](arg1);
	}
	return entity [[func]]();
}

/*
	Name: new_func
	Namespace: util
	Checksum: 0x4EDC8ACE
	Offset: 0x25A8
	Size: 0xE8
	Parameters: 7
	Flags: None
*/
function new_func(func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	s_func = spawnstruct();
	s_func.func = func;
	s_func.arg1 = arg1;
	s_func.arg2 = arg2;
	s_func.arg3 = arg3;
	s_func.arg4 = arg4;
	s_func.arg5 = arg5;
	s_func.arg6 = arg6;
	return s_func;
}

/*
	Name: call_func
	Namespace: util
	Checksum: 0x24BBD6AF
	Offset: 0x2698
	Size: 0x72
	Parameters: 1
	Flags: None
*/
function call_func(s_func)
{
	return single_func(self, s_func.func, s_func.arg1, s_func.arg2, s_func.arg3, s_func.arg4, s_func.arg5, s_func.arg6);
}

/*
	Name: single_thread
	Namespace: util
	Checksum: 0x99D39132
	Offset: 0x2718
	Size: 0x184
	Parameters: 8
	Flags: Linked
*/
function single_thread(entity, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	/#
		assert(isdefined(entity), "");
	#/
	if(isdefined(arg6))
	{
		entity thread [[func]](arg1, arg2, arg3, arg4, arg5, arg6);
	}
	else
	{
		if(isdefined(arg5))
		{
			entity thread [[func]](arg1, arg2, arg3, arg4, arg5);
		}
		else
		{
			if(isdefined(arg4))
			{
				entity thread [[func]](arg1, arg2, arg3, arg4);
			}
			else
			{
				if(isdefined(arg3))
				{
					entity thread [[func]](arg1, arg2, arg3);
				}
				else
				{
					if(isdefined(arg2))
					{
						entity thread [[func]](arg1, arg2);
					}
					else
					{
						if(isdefined(arg1))
						{
							entity thread [[func]](arg1);
						}
						else
						{
							entity thread [[func]]();
						}
					}
				}
			}
		}
	}
}

/*
	Name: script_delay
	Namespace: util
	Checksum: 0xD8472350
	Offset: 0x28A8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function script_delay()
{
	if(isdefined(self.script_delay))
	{
		wait(self.script_delay);
		return true;
	}
	if(isdefined(self.script_delay_min) && isdefined(self.script_delay_max))
	{
		if(self.script_delay_max > self.script_delay_min)
		{
			wait(randomfloatrange(self.script_delay_min, self.script_delay_max));
		}
		else
		{
			wait(self.script_delay_min);
		}
		return true;
	}
	return false;
}

/*
	Name: timeout
	Namespace: util
	Checksum: 0x8D188C1
	Offset: 0x2938
	Size: 0xCC
	Parameters: 8
	Flags: Linked
*/
function timeout(n_time, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	if(isdefined(n_time))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s delay_notify(n_time, "timeout");
	}
	single_func(self, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: create_flags_and_return_tokens
	Namespace: util
	Checksum: 0x640CFC76
	Offset: 0x2A10
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function create_flags_and_return_tokens(flags)
{
	tokens = strtok(flags, " ");
	for(i = 0; i < tokens.size; i++)
	{
		if(!level flag::exists(tokens[i]))
		{
			level flag::init(tokens[i], undefined, 1);
		}
	}
	return tokens;
}

/*
	Name: fileprint_start
	Namespace: util
	Checksum: 0xB15BB138
	Offset: 0x2AC8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function fileprint_start(file)
{
	/#
		filename = file;
		file = openfile(filename, "");
		level.fileprint = file;
		level.fileprintlinecount = 0;
		level.fileprint_filename = filename;
	#/
}

/*
	Name: fileprint_map_start
	Namespace: util
	Checksum: 0x22631536
	Offset: 0x2B38
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function fileprint_map_start(file)
{
	/#
		file = ("" + file) + "";
		fileprint_start(file);
		level.fileprint_mapentcount = 0;
		fileprint_map_header(1);
	#/
}

/*
	Name: fileprint_chk
	Namespace: util
	Checksum: 0x9960EFAA
	Offset: 0x2BA8
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function fileprint_chk(file, str)
{
	/#
		level.fileprintlinecount++;
		if(level.fileprintlinecount > 400)
		{
			wait(0.05);
			level.fileprintlinecount++;
			level.fileprintlinecount = 0;
		}
		fprintln(file, str);
	#/
}

/*
	Name: fileprint_map_header
	Namespace: util
	Checksum: 0x95328F7F
	Offset: 0x2C18
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function fileprint_map_header(binclude_blank_worldspawn = 0)
{
	/#
		assert(isdefined(level.fileprint));
	#/
	/#
		fileprint_chk(level.fileprint, "");
		fileprint_chk(level.fileprint, "");
		fileprint_chk(level.fileprint, "");
		if(!binclude_blank_worldspawn)
		{
			return;
		}
		fileprint_map_entity_start();
		fileprint_map_keypairprint("", "");
		fileprint_map_entity_end();
	#/
}

/*
	Name: fileprint_map_keypairprint
	Namespace: util
	Checksum: 0xBD95B79B
	Offset: 0x2D18
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function fileprint_map_keypairprint(key1, key2)
{
	/#
		/#
			assert(isdefined(level.fileprint));
		#/
		fileprint_chk(level.fileprint, ((("" + key1) + "") + key2) + "");
	#/
}

/*
	Name: fileprint_map_entity_start
	Namespace: util
	Checksum: 0xD6ECF47F
	Offset: 0x2DA0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function fileprint_map_entity_start()
{
	/#
		/#
			assert(!isdefined(level.fileprint_entitystart));
		#/
		level.fileprint_entitystart = 1;
		/#
			assert(isdefined(level.fileprint));
		#/
		fileprint_chk(level.fileprint, "" + level.fileprint_mapentcount);
		fileprint_chk(level.fileprint, "");
		level.fileprint_mapentcount++;
	#/
}

/*
	Name: fileprint_map_entity_end
	Namespace: util
	Checksum: 0x420399C5
	Offset: 0x2E58
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function fileprint_map_entity_end()
{
	/#
		/#
			assert(isdefined(level.fileprint_entitystart));
		#/
		/#
			assert(isdefined(level.fileprint));
		#/
		level.fileprint_entitystart = undefined;
		fileprint_chk(level.fileprint, "");
	#/
}

/*
	Name: fileprint_end
	Namespace: util
	Checksum: 0xA7EC44F9
	Offset: 0x2ED8
	Size: 0x25E
	Parameters: 0
	Flags: None
*/
function fileprint_end()
{
	/#
		/#
			assert(!isdefined(level.fileprint_entitystart));
		#/
		saved = closefile(level.fileprint);
		if(saved != 1)
		{
			println("");
			println("");
			println("");
			println("" + level.fileprint_filename);
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
			println("");
		}
		level.fileprint = undefined;
		level.fileprint_filename = undefined;
	#/
}

/*
	Name: fileprint_radiant_vec
	Namespace: util
	Checksum: 0x90472F71
	Offset: 0x3140
	Size: 0x62
	Parameters: 1
	Flags: None
*/
function fileprint_radiant_vec(vector)
{
	/#
		string = ((((("" + vector[0]) + "") + vector[1]) + "") + vector[2]) + "";
		return string;
	#/
}

/*
	Name: death_notify_wrapper
	Namespace: util
	Checksum: 0xA529E94
	Offset: 0x31B0
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function death_notify_wrapper(attacker, damagetype)
{
	level notify(#"face", "death", self);
	self notify(#"death", attacker, damagetype);
}

/*
	Name: damage_notify_wrapper
	Namespace: util
	Checksum: 0xCF9F8BE3
	Offset: 0x31F8
	Size: 0x92
	Parameters: 9
	Flags: Linked
*/
function damage_notify_wrapper(damage, attacker, direction_vec, point, type, modelname, tagname, partname, idflags)
{
	level notify(#"face", "damage", self);
	self notify(#"damage", damage, attacker, direction_vec, point, type, modelname, tagname, partname, idflags);
}

/*
	Name: explode_notify_wrapper
	Namespace: util
	Checksum: 0x7F145899
	Offset: 0x3298
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function explode_notify_wrapper()
{
	level notify(#"face", "explode", self);
	self notify(#"explode");
}

/*
	Name: alert_notify_wrapper
	Namespace: util
	Checksum: 0x7851D5D7
	Offset: 0x32C8
	Size: 0x26
	Parameters: 0
	Flags: None
*/
function alert_notify_wrapper()
{
	level notify(#"face", "alert", self);
	self notify(#"alert");
}

/*
	Name: shoot_notify_wrapper
	Namespace: util
	Checksum: 0x86F3F8D9
	Offset: 0x32F8
	Size: 0x26
	Parameters: 0
	Flags: None
*/
function shoot_notify_wrapper()
{
	level notify(#"face", "shoot", self);
	self notify(#"shoot");
}

/*
	Name: melee_notify_wrapper
	Namespace: util
	Checksum: 0xC2917E90
	Offset: 0x3328
	Size: 0x26
	Parameters: 0
	Flags: None
*/
function melee_notify_wrapper()
{
	level notify(#"face", "melee", self);
	self notify(#"melee");
}

/*
	Name: isusabilityenabled
	Namespace: util
	Checksum: 0x5B39E015
	Offset: 0x3358
	Size: 0xC
	Parameters: 0
	Flags: None
*/
function isusabilityenabled()
{
	return !self.disabledusability;
}

/*
	Name: _disableusability
	Namespace: util
	Checksum: 0xCC0896EE
	Offset: 0x3370
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function _disableusability()
{
	self.disabledusability++;
	self disableusability();
}

/*
	Name: _enableusability
	Namespace: util
	Checksum: 0xE4810DEE
	Offset: 0x33A0
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function _enableusability()
{
	self.disabledusability--;
	/#
		assert(self.disabledusability >= 0);
	#/
	if(!self.disabledusability)
	{
		self enableusability();
	}
}

/*
	Name: resetusability
	Namespace: util
	Checksum: 0x849256FD
	Offset: 0x33F8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function resetusability()
{
	self.disabledusability = 0;
	self enableusability();
}

/*
	Name: _disableweapon
	Namespace: util
	Checksum: 0x353F58D5
	Offset: 0x3428
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function _disableweapon()
{
	if(!isdefined(self.disabledweapon))
	{
		self.disabledweapon = 0;
	}
	self.disabledweapon++;
	self disableweapons();
}

/*
	Name: _enableweapon
	Namespace: util
	Checksum: 0xE7808E32
	Offset: 0x3470
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function _enableweapon()
{
	if(self.disabledweapon > 0)
	{
		self.disabledweapon--;
		if(!self.disabledweapon)
		{
			self enableweapons();
		}
	}
}

/*
	Name: isweaponenabled
	Namespace: util
	Checksum: 0x557C22F2
	Offset: 0x34B8
	Size: 0xC
	Parameters: 0
	Flags: None
*/
function isweaponenabled()
{
	return !self.disabledweapon;
}

/*
	Name: orient_to_normal
	Namespace: util
	Checksum: 0x21B9989
	Offset: 0x34D0
	Size: 0xF4
	Parameters: 1
	Flags: None
*/
function orient_to_normal(normal)
{
	hor_normal = (normal[0], normal[1], 0);
	hor_length = length(hor_normal);
	if(!hor_length)
	{
		return (0, 0, 0);
	}
	hor_dir = vectornormalize(hor_normal);
	neg_height = normal[2] * -1;
	tangent = (hor_dir[0] * neg_height, hor_dir[1] * neg_height, hor_length);
	plant_angle = vectortoangles(tangent);
	return plant_angle;
}

/*
	Name: delay
	Namespace: util
	Checksum: 0xF0F60ED0
	Offset: 0x35D0
	Size: 0x84
	Parameters: 9
	Flags: Linked
*/
function delay(time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self thread _delay(time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: _delay
	Namespace: util
	Checksum: 0x900C6D85
	Offset: 0x3660
	Size: 0xC4
	Parameters: 9
	Flags: Linked
*/
function _delay(time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self endon(#"death");
	if(isdefined(str_endon))
	{
		self endon(str_endon);
	}
	if(isstring(time_or_notify))
	{
		self waittill(time_or_notify);
	}
	else
	{
		wait(time_or_notify);
	}
	single_func(self, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: delay_network_frames
	Namespace: util
	Checksum: 0xC439C538
	Offset: 0x3730
	Size: 0x84
	Parameters: 9
	Flags: None
*/
function delay_network_frames(n_frames, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self thread _delay_network_frames(n_frames, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: _delay_network_frames
	Namespace: util
	Checksum: 0x4B1D49FD
	Offset: 0x37C0
	Size: 0xAC
	Parameters: 9
	Flags: Linked
*/
function _delay_network_frames(n_frames, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self endon(#"entityshutdown");
	if(isdefined(str_endon))
	{
		self endon(str_endon);
	}
	wait_network_frame(n_frames);
	single_func(self, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: delay_notify
	Namespace: util
	Checksum: 0xB2A47F6B
	Offset: 0x3878
	Size: 0x7C
	Parameters: 8
	Flags: Linked
*/
function delay_notify(time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5)
{
	self thread _delay_notify(time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5);
}

/*
	Name: _delay_notify
	Namespace: util
	Checksum: 0xFE893EE8
	Offset: 0x3900
	Size: 0xA8
	Parameters: 8
	Flags: Linked
*/
function _delay_notify(time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5)
{
	self endon(#"death");
	if(isdefined(str_endon))
	{
		self endon(str_endon);
	}
	if(isstring(time_or_notify))
	{
		self waittill(time_or_notify);
	}
	else
	{
		wait(time_or_notify);
	}
	self notify(str_notify, arg1, arg2, arg3, arg4, arg5);
}

/*
	Name: get_closest_player
	Namespace: util
	Checksum: 0xEFB2A1C8
	Offset: 0x39B0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function get_closest_player(org, str_team)
{
	players = getplayers(str_team);
	return arraysort(players, org, 1, 1)[0];
}

/*
	Name: registerclientsys
	Namespace: util
	Checksum: 0x76FD5BC0
	Offset: 0x3A18
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function registerclientsys(ssysname)
{
	if(!isdefined(level._clientsys))
	{
		level._clientsys = [];
	}
	if(level._clientsys.size >= 32)
	{
		/#
			/#
				assertmsg("");
			#/
		#/
		return;
	}
	if(isdefined(level._clientsys[ssysname]))
	{
		/#
			/#
				assertmsg("" + ssysname);
			#/
		#/
		return;
	}
	level._clientsys[ssysname] = spawnstruct();
	level._clientsys[ssysname].sysid = clientsysregister(ssysname);
}

/*
	Name: setclientsysstate
	Namespace: util
	Checksum: 0xCE16F5F8
	Offset: 0x3B10
	Size: 0x118
	Parameters: 3
	Flags: Linked
*/
function setclientsysstate(ssysname, ssysstate, player)
{
	if(!isdefined(level._clientsys))
	{
		/#
			/#
				assertmsg("");
			#/
		#/
		return;
	}
	if(!isdefined(level._clientsys[ssysname]))
	{
		/#
			/#
				assertmsg("" + ssysname);
			#/
		#/
		return;
	}
	if(isdefined(player))
	{
		player clientsyssetstate(level._clientsys[ssysname].sysid, ssysstate);
	}
	else
	{
		clientsyssetstate(level._clientsys[ssysname].sysid, ssysstate);
		level._clientsys[ssysname].sysstate = ssysstate;
	}
}

/*
	Name: getclientsysstate
	Namespace: util
	Checksum: 0xB5E55DA9
	Offset: 0x3C30
	Size: 0xC6
	Parameters: 1
	Flags: None
*/
function getclientsysstate(ssysname)
{
	if(!isdefined(level._clientsys))
	{
		/#
			/#
				assertmsg("");
			#/
		#/
		return "";
	}
	if(!isdefined(level._clientsys[ssysname]))
	{
		/#
			/#
				assertmsg(("" + ssysname) + "");
			#/
		#/
		return "";
	}
	if(isdefined(level._clientsys[ssysname].sysstate))
	{
		return level._clientsys[ssysname].sysstate;
	}
	return "";
}

/*
	Name: clientnotify
	Namespace: util
	Checksum: 0x10AE3DA9
	Offset: 0x3D00
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function clientnotify(event)
{
	if(level.clientscripts)
	{
		if(isplayer(self))
		{
			setclientsysstate("levelNotify", event, self);
		}
		else
		{
			setclientsysstate("levelNotify", event);
		}
	}
}

/*
	Name: coopgame
	Namespace: util
	Checksum: 0x133BF790
	Offset: 0x3D78
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function coopgame()
{
	return sessionmodeissystemlink() || (sessionmodeisonlinegame() || issplitscreen());
}

/*
	Name: is_looking_at
	Namespace: util
	Checksum: 0x65DCBE5D
	Offset: 0x3DC8
	Size: 0x1DA
	Parameters: 4
	Flags: Linked
*/
function is_looking_at(ent_or_org, n_dot_range = 0.67, do_trace = 0, v_offset)
{
	/#
		assert(isdefined(ent_or_org), "");
	#/
	v_point = (isvec(ent_or_org) ? ent_or_org : ent_or_org.origin);
	if(isvec(v_offset))
	{
		v_point = v_point + v_offset;
	}
	b_can_see = 0;
	b_use_tag_eye = 0;
	if(isplayer(self) || isai(self))
	{
		b_use_tag_eye = 1;
	}
	n_dot = self math::get_dot_direction(v_point, 0, 1, "forward", b_use_tag_eye);
	if(n_dot > n_dot_range)
	{
		if(do_trace)
		{
			v_eye = self get_eye();
			b_can_see = sighttracepassed(v_eye, v_point, 0, ent_or_org);
		}
		else
		{
			b_can_see = 1;
		}
	}
	return b_can_see;
}

/*
	Name: get_eye
	Namespace: util
	Checksum: 0x3747916F
	Offset: 0x3FB0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function get_eye()
{
	if(isplayer(self))
	{
		linked_ent = self getlinkedent();
		if(isdefined(linked_ent) && getdvarint("cg_cameraUseTagCamera") > 0)
		{
			camera = linked_ent gettagorigin("tag_camera");
			if(isdefined(camera))
			{
				return camera;
			}
		}
	}
	pos = self geteye();
	return pos;
}

/*
	Name: is_ads
	Namespace: util
	Checksum: 0xAC1840F3
	Offset: 0x4080
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function is_ads()
{
	return self playerads() > 0.5;
}

/*
	Name: spawn_model
	Namespace: util
	Checksum: 0x99F64631
	Offset: 0x40B0
	Size: 0xEC
	Parameters: 5
	Flags: Linked
*/
function spawn_model(model_name, origin, angles, n_spawnflags = 0, b_throttle = 0)
{
	if(b_throttle)
	{
		spawner::global_spawn_throttle(1);
	}
	if(!isdefined(origin))
	{
		origin = (0, 0, 0);
	}
	model = spawn("script_model", origin, n_spawnflags);
	model setmodel(model_name);
	if(isdefined(angles))
	{
		model.angles = angles;
	}
	return model;
}

/*
	Name: spawn_anim_model
	Namespace: util
	Checksum: 0xD250EA5E
	Offset: 0x41A8
	Size: 0xA4
	Parameters: 5
	Flags: Linked
*/
function spawn_anim_model(model_name, origin, angles, n_spawnflags = 0, b_throttle)
{
	model = spawn_model(model_name, origin, angles, n_spawnflags, b_throttle);
	model useanimtree($generic);
	model.animtree = "generic";
	return model;
}

/*
	Name: spawn_anim_player_model
	Namespace: util
	Checksum: 0xD032C41D
	Offset: 0x4258
	Size: 0x9C
	Parameters: 4
	Flags: Linked
*/
function spawn_anim_player_model(model_name, origin, angles, n_spawnflags = 0)
{
	model = spawn_model(model_name, origin, angles, n_spawnflags);
	model useanimtree($all_player);
	model.animtree = "all_player";
	return model;
}

/*
	Name: waittill_player_looking_at
	Namespace: util
	Checksum: 0xA20D3AD6
	Offset: 0x4300
	Size: 0xC4
	Parameters: 4
	Flags: Linked
*/
function waittill_player_looking_at(origin, arc_angle_degrees = 90, do_trace, e_ignore)
{
	self endon(#"death");
	arc_angle_degrees = absangleclamp360(arc_angle_degrees);
	dot = cos(arc_angle_degrees * 0.5);
	while(!is_player_looking_at(origin, dot, do_trace, e_ignore))
	{
		wait(0.05);
	}
}

/*
	Name: waittill_player_not_looking_at
	Namespace: util
	Checksum: 0x465DC933
	Offset: 0x43D0
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function waittill_player_not_looking_at(origin, dot, do_trace)
{
	self endon(#"death");
	while(is_player_looking_at(origin, dot, do_trace))
	{
		wait(0.05);
	}
}

/*
	Name: is_player_looking_at
	Namespace: util
	Checksum: 0x5C5791E6
	Offset: 0x4430
	Size: 0x160
	Parameters: 4
	Flags: Linked
*/
function is_player_looking_at(origin, dot, do_trace, ignore_ent)
{
	/#
		assert(isplayer(self), "");
	#/
	if(!isdefined(dot))
	{
		dot = 0.7;
	}
	if(!isdefined(do_trace))
	{
		do_trace = 1;
	}
	eye = self get_eye();
	delta_vec = vectornormalize(origin - eye);
	view_vec = anglestoforward(self getplayerangles());
	new_dot = vectordot(delta_vec, view_vec);
	if(new_dot >= dot)
	{
		if(do_trace)
		{
			return bullettracepassed(origin, eye, 0, ignore_ent);
		}
		return 1;
	}
	return 0;
}

/*
	Name: wait_endon
	Namespace: util
	Checksum: 0x2D839133
	Offset: 0x4598
	Size: 0x74
	Parameters: 5
	Flags: Linked
*/
function wait_endon(waittime, endonstring, endonstring2, endonstring3, endonstring4)
{
	self endon(endonstring);
	if(isdefined(endonstring2))
	{
		self endon(endonstring2);
	}
	if(isdefined(endonstring3))
	{
		self endon(endonstring3);
	}
	if(isdefined(endonstring4))
	{
		self endon(endonstring4);
	}
	wait(waittime);
	return true;
}

/*
	Name: waittillendonthreaded
	Namespace: util
	Checksum: 0xD1E55D02
	Offset: 0x4618
	Size: 0x86
	Parameters: 5
	Flags: None
*/
function waittillendonthreaded(waitcondition, callback, endcondition1, endcondition2, endcondition3)
{
	if(isdefined(endcondition1))
	{
		self endon(endcondition1);
	}
	if(isdefined(endcondition2))
	{
		self endon(endcondition2);
	}
	if(isdefined(endcondition3))
	{
		self endon(endcondition3);
	}
	self waittill(waitcondition);
	if(isdefined(callback))
	{
		[[callback]](waitcondition);
	}
}

/*
	Name: new_timer
	Namespace: util
	Checksum: 0xABE50925
	Offset: 0x46A8
	Size: 0x50
	Parameters: 1
	Flags: None
*/
function new_timer(n_timer_length)
{
	s_timer = spawnstruct();
	s_timer.n_time_created = gettime();
	s_timer.n_length = n_timer_length;
	return s_timer;
}

/*
	Name: get_time
	Namespace: util
	Checksum: 0x844FF1F2
	Offset: 0x4700
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function get_time()
{
	t_now = gettime();
	return t_now - self.n_time_created;
}

/*
	Name: get_time_in_seconds
	Namespace: util
	Checksum: 0xE6971794
	Offset: 0x4728
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function get_time_in_seconds()
{
	return get_time() / 1000;
}

/*
	Name: get_time_frac
	Namespace: util
	Checksum: 0x4DE86BE0
	Offset: 0x4748
	Size: 0x52
	Parameters: 1
	Flags: None
*/
function get_time_frac(n_end_time = self.n_length)
{
	return lerpfloat(0, 1, get_time_in_seconds() / n_end_time);
}

/*
	Name: get_time_left
	Namespace: util
	Checksum: 0xEF79D6F7
	Offset: 0x47A8
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function get_time_left()
{
	if(isdefined(self.n_length))
	{
		n_current_time = get_time_in_seconds();
		return max(self.n_length - n_current_time, 0);
	}
	return -1;
}

/*
	Name: is_time_left
	Namespace: util
	Checksum: 0x320C693A
	Offset: 0x4808
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function is_time_left()
{
	return get_time_left() != 0;
}

/*
	Name: timer_wait
	Namespace: util
	Checksum: 0x5B9BD5C2
	Offset: 0x4828
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function timer_wait(n_wait)
{
	if(isdefined(self.n_length))
	{
		n_wait = min(n_wait, get_time_left());
	}
	wait(n_wait);
	n_current_time = get_time_in_seconds();
	return n_current_time;
}

/*
	Name: is_primary_damage
	Namespace: util
	Checksum: 0x7CB18FB0
	Offset: 0x48A0
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function is_primary_damage(meansofdeath)
{
	if(meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET")
	{
		return true;
	}
	return false;
}

/*
	Name: delete_on_death
	Namespace: util
	Checksum: 0x7F2C84A4
	Offset: 0x48E0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function delete_on_death(ent)
{
	ent endon(#"death");
	self waittill(#"death");
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: delete_on_death_or_notify
	Namespace: util
	Checksum: 0x25FA6D63
	Offset: 0x4930
	Size: 0xAC
	Parameters: 3
	Flags: None
*/
function delete_on_death_or_notify(e_to_delete, str_notify, str_clientfield = undefined)
{
	e_to_delete endon(#"death");
	self waittill_either("death", str_notify);
	if(isdefined(e_to_delete))
	{
		if(isdefined(str_clientfield))
		{
			e_to_delete clientfield::set(str_clientfield, 0);
			wait(0.1);
		}
		e_to_delete delete();
	}
}

/*
	Name: wait_till_not_touching
	Namespace: util
	Checksum: 0xA2896E
	Offset: 0x49E8
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function wait_till_not_touching(e_to_check, e_to_touch)
{
	/#
		assert(isdefined(e_to_check), "");
	#/
	/#
		assert(isdefined(e_to_touch), "");
	#/
	e_to_check endon(#"death");
	e_to_touch endon(#"death");
	while(e_to_check istouching(e_to_touch))
	{
		wait(0.05);
	}
}

/*
	Name: any_player_is_touching
	Namespace: util
	Checksum: 0xC4A4D302
	Offset: 0x4A98
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function any_player_is_touching(ent, str_team)
{
	foreach(player in getplayers(str_team))
	{
		if(isalive(player) && player istouching(ent))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: waittill_notify_or_timeout
	Namespace: util
	Checksum: 0x6399CB0
	Offset: 0x4B78
	Size: 0x26
	Parameters: 2
	Flags: Linked
*/
function waittill_notify_or_timeout(msg, timer)
{
	self endon(msg);
	wait(timer);
	return true;
}

/*
	Name: set_console_status
	Namespace: util
	Checksum: 0xE182DCD9
	Offset: 0x4BA8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function set_console_status()
{
	if(!isdefined(level.console))
	{
		level.console = getdvarstring("consoleGame") == "true";
	}
	else
	{
		/#
			assert(level.console == getdvarstring("") == "", "");
		#/
	}
	if(!isdefined(level.consolexenon))
	{
		level.xenon = getdvarstring("xenonGame") == "true";
	}
	else
	{
		/#
			assert(level.xenon == getdvarstring("") == "", "");
		#/
	}
}

/*
	Name: waittill_asset_loaded
	Namespace: util
	Checksum: 0xA37347C5
	Offset: 0x4CB8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function waittill_asset_loaded(str_type, str_name)
{
}

/*
	Name: script_wait
	Namespace: util
	Checksum: 0x4E2E00B3
	Offset: 0x4CD8
	Size: 0x190
	Parameters: 1
	Flags: Linked
*/
function script_wait(called_from_spawner = 0)
{
	coop_scalar = 1;
	if(called_from_spawner)
	{
		players = getplayers();
		if(players.size == 2)
		{
			coop_scalar = 0.7;
		}
		else
		{
			if(players.size == 3)
			{
				coop_scalar = 0.4;
			}
			else if(players.size == 4)
			{
				coop_scalar = 0.1;
			}
		}
	}
	starttime = gettime();
	if(isdefined(self.script_wait))
	{
		wait(self.script_wait * coop_scalar);
		if(isdefined(self.script_wait_add))
		{
			self.script_wait = self.script_wait + self.script_wait_add;
		}
	}
	else if(isdefined(self.script_wait_min) && isdefined(self.script_wait_max))
	{
		wait(randomfloatrange(self.script_wait_min, self.script_wait_max) * coop_scalar);
		if(isdefined(self.script_wait_add))
		{
			self.script_wait_min = self.script_wait_min + self.script_wait_add;
			self.script_wait_max = self.script_wait_max + self.script_wait_add;
		}
	}
	return gettime() - starttime;
}

/*
	Name: is_killstreaks_enabled
	Namespace: util
	Checksum: 0xDEFCF40D
	Offset: 0x4E70
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function is_killstreaks_enabled()
{
	return isdefined(level.killstreaksenabled) && level.killstreaksenabled;
}

/*
	Name: is_flashbanged
	Namespace: util
	Checksum: 0xE8FC524
	Offset: 0x4E90
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function is_flashbanged()
{
	return isdefined(self.flashendtime) && gettime() < self.flashendtime;
}

/*
	Name: magic_bullet_shield
	Namespace: util
	Checksum: 0xCCE9549
	Offset: 0x4EB8
	Size: 0x110
	Parameters: 1
	Flags: None
*/
function magic_bullet_shield(ent = self)
{
	ent.allowdeath = 0;
	ent.magic_bullet_shield = 1;
	/#
		ent notify(#"_stop_magic_bullet_shield_debug");
		level thread debug_magic_bullet_shield_death(ent);
	#/
	/#
		assert(isalive(ent), "");
	#/
	if(isai(ent))
	{
		if(isactor(ent))
		{
			ent bloodimpact("hero");
		}
		ent.attackeraccuracy = 0.1;
	}
}

/*
	Name: debug_magic_bullet_shield_death
	Namespace: util
	Checksum: 0x41717B7
	Offset: 0x4FD0
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function debug_magic_bullet_shield_death(guy)
{
	targetname = "none";
	if(isdefined(guy.targetname))
	{
		targetname = guy.targetname;
	}
	guy endon(#"stop_magic_bullet_shield");
	guy endon(#"_stop_magic_bullet_shield_debug");
	guy waittill(#"death");
	/#
		assert(!isdefined(guy), "" + targetname);
	#/
}

/*
	Name: spawn_player_clone
	Namespace: util
	Checksum: 0xD6051E10
	Offset: 0x5078
	Size: 0x258
	Parameters: 2
	Flags: None
*/
function spawn_player_clone(player, animname)
{
	playerclone = spawn("script_model", player.origin);
	playerclone.angles = player.angles;
	bodymodel = player getcharacterbodymodel();
	playerclone setmodel(bodymodel);
	headmodel = player getcharacterheadmodel();
	if(isdefined(headmodel))
	{
		playerclone attach(headmodel, "");
	}
	helmetmodel = player getcharacterhelmetmodel();
	if(isdefined(helmetmodel))
	{
		playerclone attach(helmetmodel, "");
	}
	bodyrenderoptions = player getcharacterbodyrenderoptions();
	playerclone setbodyrenderoptions(bodyrenderoptions, bodyrenderoptions, bodyrenderoptions);
	playerclone useanimtree($all_player);
	if(isdefined(animname))
	{
		playerclone animscripted("clone_anim", playerclone.origin, playerclone.angles, animname);
	}
	playerclone.health = 100;
	playerclone setowner(player);
	playerclone.team = player.team;
	playerclone solid();
	return playerclone;
}

/*
	Name: stop_magic_bullet_shield
	Namespace: util
	Checksum: 0xBAD221CD
	Offset: 0x52D8
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function stop_magic_bullet_shield(ent = self)
{
	ent.allowdeath = 1;
	ent.magic_bullet_shield = undefined;
	if(isai(ent))
	{
		if(isactor(ent))
		{
			ent bloodimpact("normal");
		}
		ent.attackeraccuracy = 1;
	}
	ent notify(#"stop_magic_bullet_shield");
}

/*
	Name: is_one_round
	Namespace: util
	Checksum: 0x34CA433B
	Offset: 0x5390
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function is_one_round()
{
	if(level.roundlimit == 1)
	{
		return true;
	}
	return false;
}

/*
	Name: is_first_round
	Namespace: util
	Checksum: 0x8E80E42E
	Offset: 0x53B8
	Size: 0x2E
	Parameters: 0
	Flags: None
*/
function is_first_round()
{
	if(level.roundlimit > 1 && game["roundsplayed"] == 0)
	{
		return true;
	}
	return false;
}

/*
	Name: is_lastround
	Namespace: util
	Checksum: 0xDFBF5345
	Offset: 0x53F0
	Size: 0x3A
	Parameters: 0
	Flags: None
*/
function is_lastround()
{
	if(level.roundlimit > 1 && game["roundsplayed"] >= (level.roundlimit - 1))
	{
		return true;
	}
	return false;
}

/*
	Name: get_rounds_won
	Namespace: util
	Checksum: 0xB264467B
	Offset: 0x5438
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function get_rounds_won(team)
{
	return game["roundswon"][team];
}

/*
	Name: get_other_teams_rounds_won
	Namespace: util
	Checksum: 0x249207D
	Offset: 0x5460
	Size: 0xBE
	Parameters: 1
	Flags: None
*/
function get_other_teams_rounds_won(skip_team)
{
	roundswon = 0;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		roundswon = roundswon + game["roundswon"][team];
	}
	return roundswon;
}

/*
	Name: get_rounds_played
	Namespace: util
	Checksum: 0x236717CB
	Offset: 0x5528
	Size: 0xE
	Parameters: 0
	Flags: None
*/
function get_rounds_played()
{
	return game["roundsplayed"];
}

/*
	Name: is_round_based
	Namespace: util
	Checksum: 0x50501C2B
	Offset: 0x5540
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function is_round_based()
{
	if(level.roundlimit != 1 && level.roundwinlimit != 1)
	{
		return true;
	}
	return false;
}

/*
	Name: within_fov
	Namespace: util
	Checksum: 0xCBC349DB
	Offset: 0x5578
	Size: 0xA2
	Parameters: 4
	Flags: Linked
*/
function within_fov(start_origin, start_angles, end_origin, fov)
{
	normal = vectornormalize(end_origin - start_origin);
	forward = anglestoforward(start_angles);
	dot = vectordot(forward, normal);
	return dot >= fov;
}

/*
	Name: button_held_think
	Namespace: util
	Checksum: 0x45995387
	Offset: 0x5628
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function button_held_think(which_button)
{
	self endon(#"disconnect");
	if(!isdefined(self._holding_button))
	{
		self._holding_button = [];
	}
	self._holding_button[which_button] = 0;
	time_started = 0;
	while(true)
	{
		if(self._holding_button[which_button])
		{
			if(!self [[level._button_funcs[which_button]]]())
			{
				self._holding_button[which_button] = 0;
			}
		}
		else
		{
			if(self [[level._button_funcs[which_button]]]())
			{
				if(time_started == 0)
				{
					time_started = gettime();
				}
				if((gettime() - time_started) > 250)
				{
					self._holding_button[which_button] = 1;
				}
			}
			else if(time_started != 0)
			{
				time_started = 0;
			}
		}
		wait(0.05);
	}
}

/*
	Name: use_button_held
	Namespace: util
	Checksum: 0x92383585
	Offset: 0x5750
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function use_button_held()
{
	init_button_wrappers();
	if(!isdefined(self._use_button_think_threaded))
	{
		self thread button_held_think(0);
		self._use_button_think_threaded = 1;
	}
	return self._holding_button[0];
}

/*
	Name: stance_button_held
	Namespace: util
	Checksum: 0xEBEBE79A
	Offset: 0x57A8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function stance_button_held()
{
	init_button_wrappers();
	if(!isdefined(self._stance_button_think_threaded))
	{
		self thread button_held_think(1);
		self._stance_button_think_threaded = 1;
	}
	return self._holding_button[1];
}

/*
	Name: ads_button_held
	Namespace: util
	Checksum: 0x2CBE4896
	Offset: 0x5808
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function ads_button_held()
{
	init_button_wrappers();
	if(!isdefined(self._ads_button_think_threaded))
	{
		self thread button_held_think(2);
		self._ads_button_think_threaded = 1;
	}
	return self._holding_button[2];
}

/*
	Name: attack_button_held
	Namespace: util
	Checksum: 0x7E75347A
	Offset: 0x5868
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function attack_button_held()
{
	init_button_wrappers();
	if(!isdefined(self._attack_button_think_threaded))
	{
		self thread button_held_think(3);
		self._attack_button_think_threaded = 1;
	}
	return self._holding_button[3];
}

/*
	Name: button_right_held
	Namespace: util
	Checksum: 0xD497489F
	Offset: 0x58C8
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function button_right_held()
{
	init_button_wrappers();
	if(!isdefined(self._dpad_right_button_think_threaded))
	{
		self thread button_held_think(6);
		self._dpad_right_button_think_threaded = 1;
	}
	return self._holding_button[6];
}

/*
	Name: waittill_use_button_pressed
	Namespace: util
	Checksum: 0x9A819CD3
	Offset: 0x5928
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittill_use_button_pressed()
{
	while(!self usebuttonpressed())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_use_button_held
	Namespace: util
	Checksum: 0x4C45126D
	Offset: 0x5960
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittill_use_button_held()
{
	while(!self use_button_held())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_stance_button_pressed
	Namespace: util
	Checksum: 0x408D80DC
	Offset: 0x5998
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittill_stance_button_pressed()
{
	while(!self stancebuttonpressed())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_stance_button_held
	Namespace: util
	Checksum: 0xBD1FEFCD
	Offset: 0x59D0
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittill_stance_button_held()
{
	while(!self stance_button_held())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_attack_button_pressed
	Namespace: util
	Checksum: 0xFB49759E
	Offset: 0x5A08
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function waittill_attack_button_pressed()
{
	while(!self attackbuttonpressed())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_ads_button_pressed
	Namespace: util
	Checksum: 0x99111C7B
	Offset: 0x5A40
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittill_ads_button_pressed()
{
	while(!self adsbuttonpressed())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_vehicle_move_up_button_pressed
	Namespace: util
	Checksum: 0xFDC442A1
	Offset: 0x5A78
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function waittill_vehicle_move_up_button_pressed()
{
	while(!self vehiclemoveupbuttonpressed())
	{
		wait(0.05);
	}
}

/*
	Name: init_button_wrappers
	Namespace: util
	Checksum: 0x3B07C602
	Offset: 0x5AB0
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function init_button_wrappers()
{
	if(!isdefined(level._button_funcs))
	{
		level._button_funcs[0] = &usebuttonpressed;
		level._button_funcs[2] = &adsbuttonpressed;
		level._button_funcs[3] = &attackbuttonpressed;
		level._button_funcs[1] = &stancebuttonpressed;
		level._button_funcs[6] = &actionslotfourbuttonpressed;
		/#
			level._button_funcs[4] = &up_button_pressed;
			level._button_funcs[5] = &down_button_pressed;
		#/
	}
}

/*
	Name: up_button_held
	Namespace: util
	Checksum: 0x9770C448
	Offset: 0x5BA0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function up_button_held()
{
	/#
		init_button_wrappers();
		if(!isdefined(self._up_button_think_threaded))
		{
			self thread button_held_think(4);
			self._up_button_think_threaded = 1;
		}
		return self._holding_button[4];
	#/
}

/*
	Name: down_button_held
	Namespace: util
	Checksum: 0x193B944
	Offset: 0x5C08
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function down_button_held()
{
	/#
		init_button_wrappers();
		if(!isdefined(self._down_button_think_threaded))
		{
			self thread button_held_think(5);
			self._down_button_think_threaded = 1;
		}
		return self._holding_button[5];
	#/
}

/*
	Name: up_button_pressed
	Namespace: util
	Checksum: 0x209F1AC9
	Offset: 0x5C70
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function up_button_pressed()
{
	/#
		return self buttonpressed("") || self buttonpressed("");
	#/
}

/*
	Name: waittill_up_button_pressed
	Namespace: util
	Checksum: 0xDA85DA42
	Offset: 0x5CC0
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittill_up_button_pressed()
{
	/#
		while(!self up_button_pressed())
		{
			wait(0.05);
		}
	#/
}

/*
	Name: down_button_pressed
	Namespace: util
	Checksum: 0x29ECBE16
	Offset: 0x5CF8
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function down_button_pressed()
{
	/#
		return self buttonpressed("") || self buttonpressed("");
	#/
}

/*
	Name: waittill_down_button_pressed
	Namespace: util
	Checksum: 0xA37ED3DF
	Offset: 0x5D48
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittill_down_button_pressed()
{
	/#
		while(!self down_button_pressed())
		{
			wait(0.05);
		}
	#/
}

/*
	Name: freeze_player_controls
	Namespace: util
	Checksum: 0x1B2CC398
	Offset: 0x5D80
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function freeze_player_controls(b_frozen = 1)
{
	if(isdefined(level.hostmigrationtimer))
	{
		b_frozen = 1;
	}
	if(b_frozen || !level.gameended)
	{
		self freezecontrols(b_frozen);
	}
}

/*
	Name: is_bot
	Namespace: util
	Checksum: 0xC029F559
	Offset: 0x5DF0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function is_bot()
{
	return isplayer(self) && isdefined(self.pers["isBot"]) && self.pers["isBot"] != 0;
}

/*
	Name: ishacked
	Namespace: util
	Checksum: 0xDD357881
	Offset: 0x5E48
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function ishacked()
{
	return isdefined(self.hacked) && self.hacked;
}

/*
	Name: getlastweapon
	Namespace: util
	Checksum: 0x9B3AF3B6
	Offset: 0x5E68
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function getlastweapon()
{
	last_weapon = undefined;
	if(isdefined(self.lastnonkillstreakweapon) && self hasweapon(self.lastnonkillstreakweapon))
	{
		last_weapon = self.lastnonkillstreakweapon;
	}
	else if(isdefined(self.lastdroppableweapon) && self hasweapon(self.lastdroppableweapon))
	{
		last_weapon = self.lastdroppableweapon;
	}
	return last_weapon;
}

/*
	Name: isenemyplayer
	Namespace: util
	Checksum: 0x484D35A
	Offset: 0x5F00
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function isenemyplayer(player)
{
	/#
		assert(isdefined(player));
	#/
	if(!isplayer(player))
	{
		return false;
	}
	if(level.teambased)
	{
		if(player.team == self.team)
		{
			return false;
		}
	}
	else if(player == self)
	{
		return false;
	}
	return true;
}

/*
	Name: waittillslowprocessallowed
	Namespace: util
	Checksum: 0x101DABE2
	Offset: 0x5F98
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function waittillslowprocessallowed()
{
	while(level.lastslowprocessframe == gettime())
	{
		wait(0.05);
	}
	level.lastslowprocessframe = gettime();
}

/*
	Name: get_start_time
	Namespace: util
	Checksum: 0x8DD2BB7B
	Offset: 0x5FD0
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function get_start_time()
{
	return getmicrosecondsraw();
}

/*
	Name: note_elapsed_time
	Namespace: util
	Checksum: 0xBDD83C1A
	Offset: 0x5FF0
	Size: 0xEC
	Parameters: 2
	Flags: None
*/
function note_elapsed_time(start_time, label = "unknown")
{
	/#
		elapsed_time = get_elapsed_time(start_time, getmicrosecondsraw());
		if(!isdefined(start_time))
		{
			return;
		}
		elapsed_time = elapsed_time * 0.001;
		if(!level.orbis)
		{
			elapsed_time = int(elapsed_time);
		}
		msg = ((label + "") + elapsed_time) + "";
		iprintln(msg);
	#/
}

/*
	Name: get_elapsed_time
	Namespace: util
	Checksum: 0x80050702
	Offset: 0x60E8
	Size: 0x82
	Parameters: 2
	Flags: Linked
*/
function get_elapsed_time(start_time, end_time = getmicrosecondsraw())
{
	if(!isdefined(start_time))
	{
		return undefined;
	}
	elapsed_time = end_time - start_time;
	if(elapsed_time < 0)
	{
		elapsed_time = elapsed_time + -2147483648;
	}
	return elapsed_time;
}

/*
	Name: mayapplyscreeneffect
	Namespace: util
	Checksum: 0x3C7D4AE5
	Offset: 0x6178
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function mayapplyscreeneffect()
{
	/#
		assert(isdefined(self));
	#/
	/#
		assert(isplayer(self));
	#/
	return !isdefined(self.viewlockedentity);
}

/*
	Name: waittillnotmoving
	Namespace: util
	Checksum: 0xA8CBF491
	Offset: 0x61D0
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function waittillnotmoving()
{
	if(self ishacked())
	{
		wait(0.05);
		return;
	}
	if(self.classname == "grenade")
	{
		self waittill(#"stationary");
	}
	else
	{
		prevorigin = self.origin;
		while(true)
		{
			wait(0.15);
			if(self.origin == prevorigin)
			{
				break;
			}
			prevorigin = self.origin;
		}
	}
}

/*
	Name: waittillrollingornotmoving
	Namespace: util
	Checksum: 0xA55D7523
	Offset: 0x6270
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function waittillrollingornotmoving()
{
	if(self ishacked())
	{
		wait(0.05);
		return "stationary";
	}
	movestate = self waittill_any_return("stationary", "rolling");
	return movestate;
}

/*
	Name: getstatstablename
	Namespace: util
	Checksum: 0x4150021D
	Offset: 0x62E0
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function getstatstablename()
{
	if(sessionmodeiscampaigngame())
	{
		return "gamedata/stats/cp/cp_statstable.csv";
	}
	if(sessionmodeiszombiesgame())
	{
		return "gamedata/stats/zm/zm_statstable.csv";
	}
	return "gamedata/stats/mp/mp_statstable.csv";
}

/*
	Name: getweaponclass
	Namespace: util
	Checksum: 0x970D5E25
	Offset: 0x6338
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function getweaponclass(weapon)
{
	if(weapon == level.weaponnone)
	{
		return undefined;
	}
	if(!weapon.isvalid)
	{
		return undefined;
	}
	if(!isdefined(level.weaponclassarray))
	{
		level.weaponclassarray = [];
	}
	if(isdefined(level.weaponclassarray[weapon]))
	{
		return level.weaponclassarray[weapon];
	}
	baseweaponparam = [[level.get_base_weapon_param]](weapon);
	baseweaponindex = getbaseweaponitemindex(baseweaponparam);
	weaponclass = tablelookup(getstatstablename(), 0, baseweaponindex, 2);
	level.weaponclassarray[weapon] = weaponclass;
	return weaponclass;
}

/*
	Name: isusingremote
	Namespace: util
	Checksum: 0xEF6CA5D9
	Offset: 0x6440
	Size: 0xC
	Parameters: 0
	Flags: Linked
*/
function isusingremote()
{
	return isdefined(self.usingremote);
}

/*
	Name: deleteaftertime
	Namespace: util
	Checksum: 0x2281F4B6
	Offset: 0x6458
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function deleteaftertime(time)
{
	/#
		assert(isdefined(self));
	#/
	/#
		assert(isdefined(time));
	#/
	/#
		assert(time >= 0.05);
	#/
	self thread deleteaftertimethread(time);
}

/*
	Name: deleteaftertimethread
	Namespace: util
	Checksum: 0x6EF2BEFA
	Offset: 0x64E8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function deleteaftertimethread(time)
{
	self endon(#"death");
	wait(time);
	self delete();
}

/*
	Name: waitfortime
	Namespace: util
	Checksum: 0xCB4A837C
	Offset: 0x6528
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function waitfortime(time = 0)
{
	if(time > 0)
	{
		wait(time);
	}
}

/*
	Name: waitfortimeandnetworkframe
	Namespace: util
	Checksum: 0xABB97701
	Offset: 0x6570
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function waitfortimeandnetworkframe(time = 0)
{
	start_time_ms = gettime();
	wait_network_frame();
	elapsed_time = (gettime() - start_time_ms) * 0.001;
	remaining_time = time - elapsed_time;
	if(remaining_time > 0)
	{
		wait(remaining_time);
	}
}

/*
	Name: deleteaftertimeandnetworkframe
	Namespace: util
	Checksum: 0x4800DD1C
	Offset: 0x6608
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function deleteaftertimeandnetworkframe(time)
{
	/#
		assert(isdefined(self));
	#/
	waitfortimeandnetworkframe(time);
	self delete();
}

/*
	Name: drawcylinder
	Namespace: util
	Checksum: 0xB3C1DEEF
	Offset: 0x6668
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function drawcylinder(pos, rad, height, duration, stop_notify, color, alpha)
{
	/#
		if(!isdefined(duration))
		{
			duration = 0;
		}
		level thread drawcylinder_think(pos, rad, height, duration, stop_notify, color, alpha);
	#/
}

/*
	Name: drawcylinder_think
	Namespace: util
	Checksum: 0xB48D5914
	Offset: 0x66F8
	Size: 0x314
	Parameters: 7
	Flags: Linked
*/
function drawcylinder_think(pos, rad, height, seconds, stop_notify, color, alpha)
{
	/#
		if(isdefined(stop_notify))
		{
			level endon(stop_notify);
		}
		stop_time = gettime() + (seconds * 1000);
		currad = rad;
		curheight = height;
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		if(!isdefined(alpha))
		{
			alpha = 1;
		}
		for(;;)
		{
			if(seconds > 0 && stop_time <= gettime())
			{
				return;
			}
			for(r = 0; r < 20; r++)
			{
				theta = (r / 20) * 360;
				theta2 = ((r + 1) / 20) * 360;
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0), color, alpha);
				line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight), color, alpha);
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight), color, alpha);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: get_team_alive_players_s
	Namespace: util
	Checksum: 0xA59401C9
	Offset: 0x6A18
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function get_team_alive_players_s(teamname)
{
	teamplayers_s = spawn_array_struct();
	if(isdefined(teamname) && isdefined(level.aliveplayers) && isdefined(level.aliveplayers[teamname]))
	{
		for(i = 0; i < level.aliveplayers[teamname].size; i++)
		{
			teamplayers_s.a[teamplayers_s.a.size] = level.aliveplayers[teamname][i];
		}
	}
	return teamplayers_s;
}

/*
	Name: get_other_teams_alive_players_s
	Namespace: util
	Checksum: 0xB1DCC58F
	Offset: 0x6AE0
	Size: 0x162
	Parameters: 1
	Flags: None
*/
function get_other_teams_alive_players_s(teamnametoignore)
{
	teamplayers_s = spawn_array_struct();
	if(isdefined(teamnametoignore) && isdefined(level.aliveplayers))
	{
		foreach(team in level.teams)
		{
			if(team == teamnametoignore)
			{
				continue;
			}
			foreach(player in level.aliveplayers[team])
			{
				teamplayers_s.a[teamplayers_s.a.size] = player;
			}
		}
	}
	return teamplayers_s;
}

/*
	Name: get_all_alive_players_s
	Namespace: util
	Checksum: 0x101F37F6
	Offset: 0x6C50
	Size: 0xFA
	Parameters: 0
	Flags: None
*/
function get_all_alive_players_s()
{
	allplayers_s = spawn_array_struct();
	if(isdefined(level.aliveplayers))
	{
		keys = getarraykeys(level.aliveplayers);
		for(i = 0; i < keys.size; i++)
		{
			team = keys[i];
			for(j = 0; j < level.aliveplayers[team].size; j++)
			{
				allplayers_s.a[allplayers_s.a.size] = level.aliveplayers[team][j];
			}
		}
	}
	return allplayers_s;
}

/*
	Name: spawn_array_struct
	Namespace: util
	Checksum: 0xB1A1B181
	Offset: 0x6D58
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function spawn_array_struct()
{
	s = spawnstruct();
	s.a = [];
	return s;
}

/*
	Name: gethostplayer
	Namespace: util
	Checksum: 0x5FDE2E9
	Offset: 0x6D98
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function gethostplayer()
{
	players = getplayers();
	for(index = 0; index < players.size; index++)
	{
		if(players[index] ishost())
		{
			return players[index];
		}
	}
}

/*
	Name: gethostplayerforbots
	Namespace: util
	Checksum: 0xA1DC7F68
	Offset: 0x6E18
	Size: 0x74
	Parameters: 0
	Flags: None
*/
function gethostplayerforbots()
{
	players = getplayers();
	for(index = 0; index < players.size; index++)
	{
		if(players[index] ishostforbots())
		{
			return players[index];
		}
	}
}

/*
	Name: get_array_of_closest
	Namespace: util
	Checksum: 0x9CA2CFD
	Offset: 0x6E98
	Size: 0x328
	Parameters: 5
	Flags: None
*/
function get_array_of_closest(org, array, excluders = [], max = array.size, maxdist)
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
		if(isinarray(excluders, array[i]))
		{
			continue;
		}
		if(isvec(array[i]))
		{
			length = distancesquared(org, array[i]);
		}
		else
		{
			length = distancesquared(org, array[i].origin);
		}
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
	Name: set_lighting_state
	Namespace: util
	Checksum: 0x449D6D98
	Offset: 0x71C8
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function set_lighting_state(n_state)
{
	if(isdefined(n_state))
	{
		self.lighting_state = n_state;
	}
	else
	{
		self.lighting_state = level.lighting_state;
	}
	if(isdefined(self.lighting_state))
	{
		if(self == level)
		{
			if(isdefined(level.activeplayers))
			{
				foreach(player in level.activeplayers)
				{
					player set_lighting_state(level.lighting_state);
				}
			}
		}
		else
		{
			if(isplayer(self))
			{
				self setlightingstate(self.lighting_state);
			}
			else
			{
				/#
					assertmsg("");
				#/
			}
		}
	}
}

/*
	Name: set_sun_shadow_split_distance
	Namespace: util
	Checksum: 0x7CC5229D
	Offset: 0x7318
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function set_sun_shadow_split_distance(f_distance)
{
	if(isdefined(f_distance))
	{
		self.sun_shadow_split_distance = f_distance;
	}
	else
	{
		self.sun_shadow_split_distance = level.sun_shadow_split_distance;
	}
	if(isdefined(self.sun_shadow_split_distance))
	{
		if(self == level)
		{
			if(isdefined(level.activeplayers))
			{
				foreach(player in level.activeplayers)
				{
					player set_sun_shadow_split_distance(level.sun_shadow_split_distance);
				}
			}
		}
		else
		{
			if(isplayer(self))
			{
				self setsunshadowsplitdistance(self.sun_shadow_split_distance);
			}
			else
			{
				/#
					assertmsg("");
				#/
			}
		}
	}
}

/*
	Name: auto_delete
	Namespace: util
	Checksum: 0xF9B150A4
	Offset: 0x7468
	Size: 0x49C
	Parameters: 4
	Flags: None
*/
function auto_delete(n_mode = 1, n_min_time_alive = 0, n_dist_horizontal = 0, n_dist_vertical = 0)
{
	self endon(#"death");
	self notify(#"__auto_delete__");
	self endon(#"__auto_delete__");
	level flag::wait_till("all_players_spawned");
	if(isdefined(level.heroes) && isinarray(level.heroes, self))
	{
		return;
	}
	if(n_mode & 16 || n_mode == 1 || n_mode == 8)
	{
		n_mode = n_mode | 2;
		n_mode = n_mode | 4;
	}
	n_think_time = 1;
	n_tests_to_do = 2;
	n_dot_check = 0;
	if(n_mode & 16)
	{
		n_think_time = 0.2;
		n_tests_to_do = 1;
		n_dot_check = 0.4;
	}
	n_test_count = 0;
	while(true)
	{
		do
		{
			wait(randomfloatrange(n_think_time - (n_think_time / 3), n_think_time + (n_think_time / 3)));
		}
		while(isdefined(self.birthtime) && ((gettime() - self.birthtime) / 1000) < n_min_time_alive);
		n_tests_passed = 0;
		foreach(player in level.players)
		{
			if(n_dist_horizontal && distance2dsquared(self.origin, player.origin) < n_dist_horizontal)
			{
				continue;
			}
			if(n_dist_vertical && (abs(self.origin[2] - player.origin[2])) < n_dist_vertical)
			{
				continue;
			}
			v_eye = player geteye();
			b_behind = 0;
			if(n_mode & 2)
			{
				v_facing = anglestoforward(player getplayerangles());
				v_to_ent = vectornormalize(self.origin - v_eye);
				n_dot = vectordot(v_facing, v_to_ent);
				if(n_dot < n_dot_check)
				{
					b_behind = 1;
					if(!n_mode & 1)
					{
						n_tests_passed++;
						continue;
					}
				}
			}
			if(n_mode & 4)
			{
				if(!self sightconetrace(v_eye, player))
				{
					if(b_behind || !n_mode & 1)
					{
						n_tests_passed++;
					}
				}
			}
		}
		if(n_tests_passed == level.players.size)
		{
			n_test_count++;
			if(n_test_count < n_tests_to_do)
			{
				continue;
			}
			self notify(#"_disable_reinforcement");
			self delete();
		}
		else
		{
			n_test_count = 0;
		}
	}
}

/*
	Name: query_ents
	Namespace: util
	Checksum: 0x20A20F9B
	Offset: 0x7910
	Size: 0x3F2
	Parameters: 5
	Flags: None
*/
function query_ents(&a_kvps_match, b_match_all = 1, &a_kvps_ingnore, b_ignore_spawners = 0, b_match_substrings = 0)
{
	a_ret = [];
	if(b_match_substrings)
	{
		a_all_ents = getentarray();
		b_first = 1;
		foreach(k, v in a_kvps_match)
		{
			a_ents = _query_ents_by_substring_helper(a_all_ents, v, k, b_ignore_spawners);
			if(b_first)
			{
				a_ret = a_ents;
				b_first = 0;
				continue;
			}
			if(b_match_all)
			{
				a_ret = arrayintersect(a_ret, a_ents);
				continue;
			}
			a_ret = arraycombine(a_ret, a_ents, 0, 0);
		}
		if(isdefined(a_kvps_ingnore))
		{
			foreach(k, v in a_kvps_ingnore)
			{
				a_ents = _query_ents_by_substring_helper(a_all_ents, v, k, b_ignore_spawners);
				a_ret = array::exclude(a_ret, a_ents);
			}
		}
	}
	else
	{
		b_first = 1;
		foreach(k, v in a_kvps_match)
		{
			a_ents = getentarray(v, k);
			if(b_first)
			{
				a_ret = a_ents;
				b_first = 0;
				continue;
			}
			if(b_match_all)
			{
				a_ret = arrayintersect(a_ret, a_ents);
				continue;
			}
			a_ret = arraycombine(a_ret, a_ents, 0, 0);
		}
		if(isdefined(a_kvps_ingnore))
		{
			foreach(k, v in a_kvps_ingnore)
			{
				a_ents = getentarray(v, k);
				a_ret = array::exclude(a_ret, a_ents);
			}
		}
	}
	return a_ret;
}

/*
	Name: _query_ents_by_substring_helper
	Namespace: util
	Checksum: 0xA1A1C160
	Offset: 0x7D10
	Size: 0x60C
	Parameters: 4
	Flags: Linked
*/
function _query_ents_by_substring_helper(&a_ents, str_value, str_key = "targetname", b_ignore_spawners = 0)
{
	a_ret = [];
	foreach(ent in a_ents)
	{
		if(b_ignore_spawners && isspawner(ent))
		{
			continue;
		}
		switch(str_key)
		{
			case "targetname":
			{
				if(isstring(ent.targetname) && issubstr(ent.targetname, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!isarray(a_ret))
					{
						a_ret = array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "script_noteworthy":
			{
				if(isstring(ent.script_noteworthy) && issubstr(ent.script_noteworthy, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!isarray(a_ret))
					{
						a_ret = array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "classname":
			{
				if(isstring(ent.classname) && issubstr(ent.classname, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!isarray(a_ret))
					{
						a_ret = array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "vehicletype":
			{
				if(isstring(ent.vehicletype) && issubstr(ent.vehicletype, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!isarray(a_ret))
					{
						a_ret = array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "script_string":
			{
				if(isstring(ent.script_string) && issubstr(ent.script_string, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!isarray(a_ret))
					{
						a_ret = array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "script_color_axis":
			{
				if(isstring(ent.script_color_axis) && issubstr(ent.script_color_axis, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!isarray(a_ret))
					{
						a_ret = array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "script_color_allies":
			{
				if(isstring(ent.script_color_axis) && issubstr(ent.script_color_axis, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!isarray(a_ret))
					{
						a_ret = array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			default:
			{
				/#
					assert(("" + str_key) + "");
				#/
			}
		}
	}
	return a_ret;
}

/*
	Name: get_weapon_by_name
	Namespace: util
	Checksum: 0xA847374C
	Offset: 0x8328
	Size: 0x34E
	Parameters: 1
	Flags: Linked
*/
function get_weapon_by_name(weapon_name)
{
	split = strtok(weapon_name, "+");
	switch(split.size)
	{
		case 1:
		default:
		{
			weapon = getweapon(split[0]);
			break;
		}
		case 2:
		{
			weapon = getweapon(split[0], split[1]);
			break;
		}
		case 3:
		{
			weapon = getweapon(split[0], split[1], split[2]);
			break;
		}
		case 4:
		{
			weapon = getweapon(split[0], split[1], split[2], split[3]);
			break;
		}
		case 5:
		{
			weapon = getweapon(split[0], split[1], split[2], split[3], split[4]);
			break;
		}
		case 6:
		{
			weapon = getweapon(split[0], split[1], split[2], split[3], split[4], split[5]);
			break;
		}
		case 7:
		{
			weapon = getweapon(split[0], split[1], split[2], split[3], split[4], split[5], split[6]);
			break;
		}
		case 8:
		{
			weapon = getweapon(split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7]);
			break;
		}
		case 9:
		{
			weapon = getweapon(split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7], split[8]);
			break;
		}
	}
	return weapon;
}

/*
	Name: is_female
	Namespace: util
	Checksum: 0xC171AFC9
	Offset: 0x8680
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function is_female()
{
	gender = self getplayergendertype(currentsessionmode());
	b_female = 0;
	if(isdefined(gender) && gender == "female")
	{
		b_female = 1;
	}
	return b_female;
}

/*
	Name: positionquery_pointarray
	Namespace: util
	Checksum: 0x2020085F
	Offset: 0x8700
	Size: 0x196
	Parameters: 6
	Flags: Linked
*/
function positionquery_pointarray(origin, minsearchradius, maxsearchradius, halfheight, innerspacing, reachableby_ent)
{
	if(isdefined(reachableby_ent))
	{
		queryresult = positionquery_source_navigation(origin, minsearchradius, maxsearchradius, halfheight, innerspacing, reachableby_ent);
	}
	else
	{
		queryresult = positionquery_source_navigation(origin, minsearchradius, maxsearchradius, halfheight, innerspacing);
	}
	pointarray = [];
	foreach(pointstruct in queryresult.data)
	{
		if(!isdefined(pointarray))
		{
			pointarray = [];
		}
		else if(!isarray(pointarray))
		{
			pointarray = array(pointarray);
		}
		pointarray[pointarray.size] = pointstruct.origin;
	}
	return pointarray;
}

/*
	Name: totalplayercount
	Namespace: util
	Checksum: 0xAEADF2DC
	Offset: 0x88A0
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function totalplayercount()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.playercount[team];
	}
	return count;
}

/*
	Name: isrankenabled
	Namespace: util
	Checksum: 0x92CFF701
	Offset: 0x8950
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function isrankenabled()
{
	return isdefined(level.rankenabled) && level.rankenabled;
}

/*
	Name: isoneround
	Namespace: util
	Checksum: 0xE0CBB521
	Offset: 0x8970
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function isoneround()
{
	if(level.roundlimit == 1)
	{
		return true;
	}
	return false;
}

/*
	Name: isfirstround
	Namespace: util
	Checksum: 0x9CABC86C
	Offset: 0x8998
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function isfirstround()
{
	if(level.roundlimit > 1 && game["roundsplayed"] == 0)
	{
		return true;
	}
	return false;
}

/*
	Name: islastround
	Namespace: util
	Checksum: 0x36F62146
	Offset: 0x89D0
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function islastround()
{
	if(level.roundlimit > 1 && game["roundsplayed"] >= (level.roundlimit - 1))
	{
		return true;
	}
	return false;
}

/*
	Name: waslastround
	Namespace: util
	Checksum: 0x347AB8C3
	Offset: 0x8A18
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function waslastround()
{
	if(level.forcedend)
	{
		return true;
	}
	if(isdefined(level.shouldplayovertimeround))
	{
		if([[level.shouldplayovertimeround]]())
		{
			level.nextroundisovertime = 1;
			return false;
		}
		if(isdefined(game["overtime_round"]))
		{
			return true;
		}
	}
	if(hitroundlimit() || hitscorelimit() || hitroundwinlimit())
	{
		return true;
	}
	return false;
}

/*
	Name: hitroundlimit
	Namespace: util
	Checksum: 0xB23BDF08
	Offset: 0x8AD0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function hitroundlimit()
{
	if(level.roundlimit <= 0)
	{
		return 0;
	}
	return getroundsplayed() >= level.roundlimit;
}

/*
	Name: anyteamhitroundwinlimit
	Namespace: util
	Checksum: 0xFAA9D468
	Offset: 0x8B10
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function anyteamhitroundwinlimit()
{
	foreach(team in level.teams)
	{
		if(getroundswon(team) >= level.roundwinlimit)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: anyteamhitroundlimitwithdraws
	Namespace: util
	Checksum: 0x91D81FA0
	Offset: 0x8BB8
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function anyteamhitroundlimitwithdraws()
{
	tie_wins = game["roundswon"]["tie"];
	foreach(team in level.teams)
	{
		if((getroundswon(team) + tie_wins) >= level.roundwinlimit)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: getroundwinlimitwinningteam
	Namespace: util
	Checksum: 0x89FE85
	Offset: 0x8C90
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function getroundwinlimitwinningteam()
{
	max_wins = 0;
	winning_team = undefined;
	foreach(team in level.teams)
	{
		wins = getroundswon(team);
		if(!isdefined(winning_team))
		{
			max_wins = wins;
			winning_team = team;
			continue;
		}
		if(wins == max_wins)
		{
			winning_team = "tie";
			continue;
		}
		if(wins > max_wins)
		{
			max_wins = wins;
			winning_team = team;
		}
	}
	return winning_team;
}

/*
	Name: hitroundwinlimit
	Namespace: util
	Checksum: 0xE5EB4B51
	Offset: 0x8DB8
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function hitroundwinlimit()
{
	if(!isdefined(level.roundwinlimit) || level.roundwinlimit <= 0)
	{
		return false;
	}
	if(anyteamhitroundwinlimit())
	{
		return true;
	}
	if(anyteamhitroundlimitwithdraws())
	{
		if(getroundwinlimitwinningteam() != "tie")
		{
			return true;
		}
	}
	return false;
}

/*
	Name: any_team_hit_score_limit
	Namespace: util
	Checksum: 0x96BB2848
	Offset: 0x8E40
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function any_team_hit_score_limit()
{
	foreach(team in level.teams)
	{
		if(game["teamScores"][team] >= level.scorelimit)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: hitscorelimit
	Namespace: util
	Checksum: 0xB8BFDB7B
	Offset: 0x8EE8
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function hitscorelimit()
{
	if(level.scoreroundwinbased)
	{
		return false;
	}
	if(level.scorelimit <= 0)
	{
		return false;
	}
	if(level.teambased)
	{
		if(any_team_hit_score_limit())
		{
			return true;
		}
	}
	else
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isdefined(player.pointstowin) && player.pointstowin >= level.scorelimit)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: get_current_round_score_limit
	Namespace: util
	Checksum: 0x873BDE19
	Offset: 0x8FC0
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function get_current_round_score_limit()
{
	return level.roundscorelimit * (game["roundsplayed"] + 1);
}

/*
	Name: any_team_hit_round_score_limit
	Namespace: util
	Checksum: 0xCA854C44
	Offset: 0x8FE8
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function any_team_hit_round_score_limit()
{
	round_score_limit = get_current_round_score_limit();
	foreach(team in level.teams)
	{
		if(game["teamScores"][team] >= round_score_limit)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: hitroundscorelimit
	Namespace: util
	Checksum: 0x83A31C5A
	Offset: 0x90A8
	Size: 0xDA
	Parameters: 0
	Flags: None
*/
function hitroundscorelimit()
{
	if(level.roundscorelimit <= 0)
	{
		return false;
	}
	if(level.teambased)
	{
		if(any_team_hit_round_score_limit())
		{
			return true;
		}
	}
	else
	{
		roundscorelimit = get_current_round_score_limit();
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isdefined(player.pointstowin) && player.pointstowin >= roundscorelimit)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: getroundswon
	Namespace: util
	Checksum: 0xBD2E2CF8
	Offset: 0x9190
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function getroundswon(team)
{
	return game["roundswon"][team];
}

/*
	Name: getotherteamsroundswon
	Namespace: util
	Checksum: 0xF2DBA2CF
	Offset: 0x91B8
	Size: 0xBE
	Parameters: 1
	Flags: None
*/
function getotherteamsroundswon(skip_team)
{
	roundswon = 0;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		roundswon = roundswon + game["roundswon"][team];
	}
	return roundswon;
}

/*
	Name: getroundsplayed
	Namespace: util
	Checksum: 0xE6FF0484
	Offset: 0x9280
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function getroundsplayed()
{
	return game["roundsplayed"];
}

/*
	Name: isroundbased
	Namespace: util
	Checksum: 0xA2F4ADDD
	Offset: 0x9298
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function isroundbased()
{
	if(level.roundlimit != 1 && level.roundwinlimit != 1)
	{
		return true;
	}
	return false;
}

/*
	Name: getcurrentgamemode
	Namespace: util
	Checksum: 0x1FABB68
	Offset: 0x92D0
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function getcurrentgamemode()
{
	if(gamemodeismode(6))
	{
		return "leaguematch";
	}
	return "publicmatch";
}

/*
	Name: ground_position
	Namespace: util
	Checksum: 0xCBDE9A9A
	Offset: 0x9308
	Size: 0x13A
	Parameters: 6
	Flags: None
*/
function ground_position(v_start, n_max_dist = 5000, n_ground_offset = 0, e_ignore, b_ignore_water = 0, b_ignore_glass = 0)
{
	v_trace_start = v_start + (0, 0, 5);
	v_trace_end = v_trace_start + (0, 0, (n_max_dist + 5) * -1);
	a_trace = groundtrace(v_trace_start, v_trace_end, 0, e_ignore, b_ignore_water, b_ignore_glass);
	if(a_trace["surfacetype"] != "none")
	{
		return a_trace["position"] + (0, 0, n_ground_offset);
	}
	return v_start;
}

/*
	Name: delayed_notify
	Namespace: util
	Checksum: 0x4884D367
	Offset: 0x9450
	Size: 0x2C
	Parameters: 2
	Flags: None
*/
function delayed_notify(str_notify, f_delay_seconds)
{
	wait(f_delay_seconds);
	if(isdefined(self))
	{
		self notify(str_notify);
	}
}

/*
	Name: delayed_delete
	Namespace: util
	Checksum: 0x181F7AE1
	Offset: 0x9488
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function delayed_delete(str_notify, f_delay_seconds)
{
	/#
		assert(isentity(self));
	#/
	wait(f_delay_seconds);
	if(isdefined(self) && isentity(self))
	{
		self delete();
	}
}

/*
	Name: do_chyron_text
	Namespace: util
	Checksum: 0x964EDC9
	Offset: 0x9508
	Size: 0x1AC
	Parameters: 11
	Flags: None
*/
function do_chyron_text(str_1_full, str_1_short, str_2_full, str_2_short, str_3_full, str_3_short, str_4_full, str_4_short, str_5_full = "", str_5_short = "", n_duration = 12)
{
	level.chyron_text_active = 1;
	level flagsys::set("chyron_active");
	foreach(player in level.players)
	{
		player thread player_set_chyron_menu(str_1_full, str_1_short, str_2_full, str_2_short, str_3_full, str_3_short, str_4_full, str_4_short, str_5_full, str_5_short, n_duration);
	}
	level waittill(#"chyron_menu_closed");
	level.chyron_text_active = undefined;
	level flagsys::clear("chyron_active");
}

/*
	Name: player_set_chyron_menu
	Namespace: util
	Checksum: 0xCFFBE204
	Offset: 0x96C0
	Size: 0x384
	Parameters: 11
	Flags: Linked
*/
function player_set_chyron_menu(str_1_full, str_1_short, str_2_full, str_2_short, str_3_full, str_3_short, str_4_full, str_4_short, str_5_full = "", str_5_short = "", n_duration)
{
	self endon(#"disconnect");
	/#
		assert(isdefined(n_duration), "");
	#/
	menuhandle = self openluimenu("CPChyron");
	self setluimenudata(menuhandle, "line1full", str_1_full);
	self setluimenudata(menuhandle, "line1short", str_1_short);
	self setluimenudata(menuhandle, "line2full", str_2_full);
	self setluimenudata(menuhandle, "line2short", str_2_short);
	mapname = getdvarstring("mapname");
	hideline3full = 0;
	if(mapname == "cp_mi_eth_prologue" && sessionmodeiscampaignzombiesgame())
	{
		hideline3full = 1;
	}
	if(!hideline3full)
	{
		self setluimenudata(menuhandle, "line3full", str_3_full);
		self setluimenudata(menuhandle, "line3short", str_3_short);
	}
	if(!sessionmodeiscampaignzombiesgame())
	{
		self setluimenudata(menuhandle, "line4full", str_4_full);
		self setluimenudata(menuhandle, "line4short", str_4_short);
		self setluimenudata(menuhandle, "line5full", str_5_full);
		self setluimenudata(menuhandle, "line5short", str_5_short);
	}
	waittillframeend();
	self notify(#"chyron_menu_open");
	level notify(#"chyron_menu_open");
	do
	{
		self waittill(#"menuresponse", menu, response);
	}
	while(menu != "CPChyron" || response != "closed");
	self notify(#"chyron_menu_closed");
	level notify(#"chyron_menu_closed");
	wait(5);
	self closeluimenu(menuhandle);
}

/*
	Name: get_next_safehouse
	Namespace: util
	Checksum: 0x4A8AD5A0
	Offset: 0x9A50
	Size: 0x6E
	Parameters: 1
	Flags: None
*/
function get_next_safehouse(str_next_map)
{
	switch(str_next_map)
	{
		case "cp_mi_sing_biodomes":
		case "cp_mi_sing_blackstation":
		case "cp_mi_sing_sgen":
		{
			return "cp_sh_singapore";
		}
		case "cp_mi_cairo_aquifer":
		case "cp_mi_cairo_infection":
		case "cp_mi_cairo_lotus":
		{
			return "cp_sh_cairo";
		}
		default:
		{
			return "cp_sh_mobile";
		}
	}
}

/*
	Name: is_safehouse
	Namespace: util
	Checksum: 0xF7ED560F
	Offset: 0x9AC8
	Size: 0x70
	Parameters: 0
	Flags: None
*/
function is_safehouse()
{
	mapname = tolower(getdvarstring("mapname"));
	if(mapname == "cp_sh_cairo" || mapname == "cp_sh_mobile" || mapname == "cp_sh_singapore")
	{
		return true;
	}
	return false;
}

/*
	Name: is_new_cp_map
	Namespace: util
	Checksum: 0x43F45CC6
	Offset: 0x9B40
	Size: 0xBA
	Parameters: 0
	Flags: None
*/
function is_new_cp_map()
{
	mapname = tolower(getdvarstring("mapname"));
	switch(mapname)
	{
		case "cp_mi_cairo_aquifer":
		case "cp_mi_cairo_infection":
		case "cp_mi_cairo_lotus":
		case "cp_mi_cairo_ramses":
		case "cp_mi_eth_prologue":
		case "cp_mi_sing_biodomes":
		case "cp_mi_sing_blackstation":
		case "cp_mi_sing_chinatown":
		case "cp_mi_sing_sgen":
		case "cp_mi_sing_vengeance":
		case "cp_mi_zurich_coalescene":
		case "cp_mi_zurich_newworld":
		{
			return true;
		}
		default:
		{
			return false;
		}
	}
}

/*
	Name: add_queued_debug_command
	Namespace: util
	Checksum: 0x7032DF76
	Offset: 0x9C08
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function add_queued_debug_command(cmd)
{
	/#
		if(!isdefined(level.dbg_cmd_queue))
		{
			level thread queued_debug_commands();
		}
		if(isdefined(level.dbg_cmd_queue))
		{
			array::push(level.dbg_cmd_queue, cmd, 0);
		}
	#/
}

/*
	Name: queued_debug_commands
	Namespace: util
	Checksum: 0x68553086
	Offset: 0x9C70
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function queued_debug_commands()
{
	/#
		self notify(#"queued_debug_commands");
		self endon(#"queued_debug_commands");
		if(!isdefined(level.dbg_cmd_queue))
		{
			level.dbg_cmd_queue = [];
		}
		while(true)
		{
			wait(0.05);
			if(level.dbg_cmd_queue.size == 0)
			{
				level.dbg_cmd_queue = undefined;
				return;
			}
			cmd = array::pop_front(level.dbg_cmd_queue, 0);
			adddebugcommand(cmd);
		}
	#/
}

/*
	Name: player_lock_control
	Namespace: util
	Checksum: 0x18BD3C9
	Offset: 0x9D20
	Size: 0x13C
	Parameters: 0
	Flags: None
*/
function player_lock_control()
{
	if(self == level)
	{
		foreach(e_player in level.activeplayers)
		{
			e_player freeze_player_controls(1);
			e_player scene::set_igc_active(1);
			level notify(#"disable_cybercom", e_player, 1);
			e_player show_hud(0);
		}
	}
	else
	{
		self freeze_player_controls(1);
		self scene::set_igc_active(1);
		level notify(#"disable_cybercom", self, 1);
		self show_hud(0);
	}
}

/*
	Name: player_unlock_control
	Namespace: util
	Checksum: 0xBD91552D
	Offset: 0x9E68
	Size: 0x13C
	Parameters: 0
	Flags: None
*/
function player_unlock_control()
{
	if(self == level)
	{
		foreach(e_player in level.activeplayers)
		{
			e_player freeze_player_controls(0);
			e_player scene::set_igc_active(0);
			level notify(#"enable_cybercom", e_player);
			e_player show_hud(1);
		}
	}
	else
	{
		self freeze_player_controls(0);
		self scene::set_igc_active(0);
		level notify(#"enable_cybercom", e_player);
		self show_hud(1);
	}
}

/*
	Name: show_hud
	Namespace: util
	Checksum: 0xA5EE6DD2
	Offset: 0x9FB0
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function show_hud(b_show)
{
	if(b_show)
	{
		if(!(isdefined(self.fullscreen_black_active) && self.fullscreen_black_active))
		{
			if(!self flagsys::get("playing_movie_hide_hud"))
			{
				if(!scene::is_igc_active())
				{
					if(!(isdefined(self.dont_show_hud) && self.dont_show_hud))
					{
						self setclientuivisibilityflag("hud_visible", 1);
					}
				}
			}
		}
	}
	else
	{
		self setclientuivisibilityflag("hud_visible", 0);
	}
}

/*
	Name: array_copy_if_array
	Namespace: util
	Checksum: 0x7751E1CB
	Offset: 0xA070
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function array_copy_if_array(any_var)
{
	return (isarray(any_var) ? arraycopy(any_var) : any_var);
}

/*
	Name: is_item_purchased
	Namespace: util
	Checksum: 0xD5F568CC
	Offset: 0xA0C0
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function is_item_purchased(ref)
{
	itemindex = getitemindexfromref(ref);
	return (itemindex >= 256 ? 0 : self isitempurchased(itemindex));
}

/*
	Name: has_purchased_perk_equipped
	Namespace: util
	Checksum: 0xAB3A1C31
	Offset: 0xA138
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function has_purchased_perk_equipped(ref)
{
	return self hasperk(ref) && self is_item_purchased(ref);
}

/*
	Name: has_purchased_perk_equipped_with_specific_stat
	Namespace: util
	Checksum: 0x7AB246F9
	Offset: 0xA180
	Size: 0x62
	Parameters: 2
	Flags: Linked
*/
function has_purchased_perk_equipped_with_specific_stat(single_perk_ref, stats_table_ref)
{
	if(isplayer(self))
	{
		return self hasperk(single_perk_ref) && self is_item_purchased(stats_table_ref);
	}
	return 0;
}

/*
	Name: has_flak_jacket_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xBDE4192F
	Offset: 0xA1F0
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function has_flak_jacket_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_flakjacket");
}

/*
	Name: has_blind_eye_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x59932EFC
	Offset: 0xA218
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function has_blind_eye_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_nottargetedbyairsupport", "specialty_nottargetedbyairsupport|specialty_nokillstreakreticle");
}

/*
	Name: has_ghost_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x9D68080B
	Offset: 0xA250
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function has_ghost_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_gpsjammer");
}

/*
	Name: has_tactical_mask_purchased_and_equipped
	Namespace: util
	Checksum: 0x151A8403
	Offset: 0xA278
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function has_tactical_mask_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_stunprotection", "specialty_stunprotection|specialty_flashprotection|specialty_proximityprotection");
}

/*
	Name: has_hacker_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x15F70C5E
	Offset: 0xA2B0
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function has_hacker_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_showenemyequipment", "specialty_showenemyequipment|specialty_showscorestreakicons|specialty_showenemyvehicles");
}

/*
	Name: has_cold_blooded_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x6515334D
	Offset: 0xA2E8
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function has_cold_blooded_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_nottargetedbyaitank", "specialty_nottargetedbyaitank|specialty_nottargetedbyraps|specialty_nottargetedbysentry|specialty_nottargetedbyrobot|specialty_immunenvthermal");
}

/*
	Name: has_hard_wired_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xF0B0A969
	Offset: 0xA320
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function has_hard_wired_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_immunecounteruav", "specialty_immunecounteruav|specialty_immuneemp|specialty_immunetriggerc4|specialty_immunetriggershock|specialty_immunetriggerbetty|specialty_sixthsensejammer|specialty_trackerjammer|specialty_immunesmoke");
}

/*
	Name: has_gung_ho_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x778970B4
	Offset: 0xA358
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function has_gung_ho_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_sprintfire", "specialty_sprintfire|specialty_sprintgrenadelethal|specialty_sprintgrenadetactical|specialty_sprintequipment");
}

/*
	Name: has_fast_hands_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x91D6D0CF
	Offset: 0xA390
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function has_fast_hands_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_fastweaponswitch", "specialty_fastweaponswitch|specialty_sprintrecovery|specialty_sprintfirerecovery");
}

/*
	Name: has_scavenger_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x687F0449
	Offset: 0xA3C8
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function has_scavenger_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_scavenger");
}

/*
	Name: has_jetquiet_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xC70CA53
	Offset: 0xA3F0
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function has_jetquiet_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_jetquiet", "specialty_jetnoradar|specialty_jetquiet");
}

/*
	Name: has_awareness_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xE75E7F2A
	Offset: 0xA428
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function has_awareness_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_loudenemies");
}

/*
	Name: has_ninja_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xCAFBC055
	Offset: 0xA450
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function has_ninja_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_quieter");
}

/*
	Name: has_toughness_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x5B7CA752
	Offset: 0xA478
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function has_toughness_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_bulletflinch");
}

/*
	Name: str_strip_lh
	Namespace: util
	Checksum: 0x74DB5FF
	Offset: 0xA4A0
	Size: 0x58
	Parameters: 1
	Flags: None
*/
function str_strip_lh(str)
{
	if(strendswith(str, "_lh"))
	{
		return getsubstr(str, 0, str.size - 3);
	}
	return str;
}

/*
	Name: trackwallrunningdistance
	Namespace: util
	Checksum: 0x332F1B1E
	Offset: 0xA500
	Size: 0x168
	Parameters: 0
	Flags: None
*/
function trackwallrunningdistance()
{
	self endon(#"disconnect");
	self.movementtracking.wallrunning = spawnstruct();
	self.movementtracking.wallrunning.distance = 0;
	self.movementtracking.wallrunning.count = 0;
	self.movementtracking.wallrunning.time = 0;
	while(true)
	{
		self waittill(#"wallrun_begin");
		startpos = self.origin;
		starttime = gettime();
		self.movementtracking.wallrunning.count++;
		self waittill(#"wallrun_end");
		self.movementtracking.wallrunning.distance = self.movementtracking.wallrunning.distance + distance(startpos, self.origin);
		self.movementtracking.wallrunning.time = self.movementtracking.wallrunning.time + (gettime() - starttime);
	}
}

/*
	Name: tracksprintdistance
	Namespace: util
	Checksum: 0xF475EED6
	Offset: 0xA670
	Size: 0x168
	Parameters: 0
	Flags: None
*/
function tracksprintdistance()
{
	self endon(#"disconnect");
	self.movementtracking.sprinting = spawnstruct();
	self.movementtracking.sprinting.distance = 0;
	self.movementtracking.sprinting.count = 0;
	self.movementtracking.sprinting.time = 0;
	while(true)
	{
		self waittill(#"sprint_begin");
		startpos = self.origin;
		starttime = gettime();
		self.movementtracking.sprinting.count++;
		self waittill(#"sprint_end");
		self.movementtracking.sprinting.distance = self.movementtracking.sprinting.distance + distance(startpos, self.origin);
		self.movementtracking.sprinting.time = self.movementtracking.sprinting.time + (gettime() - starttime);
	}
}

/*
	Name: trackdoublejumpdistance
	Namespace: util
	Checksum: 0x6157E4DE
	Offset: 0xA7E0
	Size: 0x168
	Parameters: 0
	Flags: None
*/
function trackdoublejumpdistance()
{
	self endon(#"disconnect");
	self.movementtracking.doublejump = spawnstruct();
	self.movementtracking.doublejump.distance = 0;
	self.movementtracking.doublejump.count = 0;
	self.movementtracking.doublejump.time = 0;
	while(true)
	{
		self waittill(#"doublejump_begin");
		startpos = self.origin;
		starttime = gettime();
		self.movementtracking.doublejump.count++;
		self waittill(#"doublejump_end");
		self.movementtracking.doublejump.distance = self.movementtracking.doublejump.distance + distance(startpos, self.origin);
		self.movementtracking.doublejump.time = self.movementtracking.doublejump.time + (gettime() - starttime);
	}
}

/*
	Name: getplayspacecenter
	Namespace: util
	Checksum: 0x26193B6B
	Offset: 0xA950
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function getplayspacecenter()
{
	minimaporigins = getentarray("minimap_corner", "targetname");
	if(minimaporigins.size)
	{
		return math::find_box_center(minimaporigins[0].origin, minimaporigins[1].origin);
	}
	return (0, 0, 0);
}

/*
	Name: getplayspacemaxwidth
	Namespace: util
	Checksum: 0x949F992B
	Offset: 0xA9C8
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function getplayspacemaxwidth()
{
	minimaporigins = getentarray("minimap_corner", "targetname");
	if(minimaporigins.size)
	{
		x = abs(minimaporigins[0].origin[0] - minimaporigins[1].origin[0]);
		y = abs(minimaporigins[0].origin[1] - minimaporigins[1].origin[1]);
		return max(x, y);
	}
	return 0;
}

/*
	Name: function_e2ac06bb
	Namespace: util
	Checksum: 0xE2C4A529
	Offset: 0xAAC8
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_e2ac06bb(menu_path, commands)
{
	adddebugcommand(((("devgui_cmd \"" + menu_path) + "\" \"") + commands) + "\"\n");
}

/*
	Name: function_181cbd1a
	Namespace: util
	Checksum: 0x842121EC
	Offset: 0xAB20
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_181cbd1a(menu_path)
{
	adddebugcommand(("devgui_remove \"" + menu_path) + "\"\n");
}

/*
	Name: function_a4c90358
	Namespace: util
	Checksum: 0x7737F3AF
	Offset: 0xAB60
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_a4c90358(counter_name, amount)
{
	if(getdvarint("live_enableCounters", 0))
	{
		incrementcounter(counter_name, amount);
	}
}

/*
	Name: function_ad904acd
	Namespace: util
	Checksum: 0x94A69868
	Offset: 0xABB8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_ad904acd()
{
	if(getdvarint("live_enableCounters", 0))
	{
		forceuploadcounters();
	}
}

/*
	Name: function_522d8c7d
	Namespace: util
	Checksum: 0xA47ABC26
	Offset: 0xABF8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_522d8c7d(amount)
{
	if(getdvarint("ui_enablePromoTracking", 0))
	{
		function_a4c90358("zmhd_thermometer", amount);
	}
}

