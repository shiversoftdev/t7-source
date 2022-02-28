// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\animation_debug_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\string_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace animation;

/*
	Name: __init__sytem__
	Namespace: animation
	Checksum: 0xF3A6087F
	Offset: 0x400
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("animation", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: animation
	Checksum: 0xC21FEE9B
	Offset: 0x440
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(getdvarstring("debug_anim_shared", "") == "")
	{
		setdvar("debug_anim_shared", "");
	}
	setup_notetracks();
}

/*
	Name: first_frame
	Namespace: animation
	Checksum: 0x49D543F3
	Offset: 0x4B0
	Size: 0x3C
	Parameters: 3
	Flags: Linked
*/
function first_frame(animation, v_origin_or_ent, v_angles_or_tag)
{
	self thread play(animation, v_origin_or_ent, v_angles_or_tag, 0);
}

/*
	Name: last_frame
	Namespace: animation
	Checksum: 0x8F834DE8
	Offset: 0x4F8
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function last_frame(animation, v_origin_or_ent, v_angles_or_tag)
{
	self thread play(animation, v_origin_or_ent, v_angles_or_tag, 0, 0, 0, 0, 1);
}

/*
	Name: play
	Namespace: animation
	Checksum: 0xA5839B39
	Offset: 0x550
	Size: 0x160
	Parameters: 10
	Flags: Linked
*/
function play(animation, v_origin_or_ent, v_angles_or_tag, n_rate = 1, n_blend_in = 0.2, n_blend_out = 0.2, n_lerp = 0, n_start_time = 0, b_show_player_firstperson_weapon = 0, b_unlink_after_completed = 1)
{
	if(sessionmodeiszombiesgame() && self isragdoll())
	{
		return;
	}
	self endon(#"death");
	self thread _play(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp, n_start_time, b_show_player_firstperson_weapon, b_unlink_after_completed);
	self waittill(#"scriptedanim");
}

/*
	Name: stop
	Namespace: animation
	Checksum: 0x55008A83
	Offset: 0x6B8
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function stop(n_blend = 0.2)
{
	flagsys::clear("scriptedanim");
	self stopanimscripted(n_blend);
}

/*
	Name: debug_print
	Namespace: animation
	Checksum: 0x708EE70E
	Offset: 0x718
	Size: 0x1B4
	Parameters: 2
	Flags: Linked
*/
function debug_print(str_animation, str_msg)
{
	/#
		str_dvar = getdvarstring("", "");
		if(str_dvar != "")
		{
			b_print = 0;
			if(strisnumber(str_dvar))
			{
				if(int(str_dvar) > 0)
				{
					b_print = 1;
				}
			}
			else if(issubstr(str_animation, str_dvar) || (isdefined(self.animname) && issubstr(self.animname, str_dvar)))
			{
				b_print = 1;
			}
			if(b_print)
			{
				printtoprightln((((str_animation + "") + string::rfill(str_msg, 10) + "") + (string::rfill("" + self getentitynumber(), 4)) + "") + (string::rfill("" + gettime(), 6)) + "", (1, 1, 0), -1);
			}
		}
	#/
}

/*
	Name: _play
	Namespace: animation
	Checksum: 0x2C4A6FC7
	Offset: 0x8D8
	Size: 0x64C
	Parameters: 10
	Flags: Linked
*/
function _play(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp, n_start_time, b_show_player_firstperson_weapon, b_unlink_after_completed)
{
	self endon(#"death");
	self notify(#"new_scripted_anim");
	self endon(#"new_scripted_anim");
	/#
		debug_print(animation, "");
	#/
	flagsys::set_val("firstframe", n_rate == 0);
	flagsys::set("scripted_anim_this_frame");
	flagsys::set("scriptedanim");
	if(!isdefined(v_origin_or_ent))
	{
		v_origin_or_ent = self;
	}
	b_link = 0;
	if(isdefined(self.n_script_anim_rate))
	{
		n_rate = self.n_script_anim_rate;
	}
	if(isvec(v_origin_or_ent) && isvec(v_angles_or_tag))
	{
		self animscripted(animation, v_origin_or_ent, v_angles_or_tag, animation, "normal", undefined, n_rate, n_blend_in, n_lerp, n_start_time, 1, b_show_player_firstperson_weapon);
	}
	else
	{
		if(isstring(v_angles_or_tag))
		{
			/#
				assert(isdefined(v_origin_or_ent.model), ((("" + animation) + "") + v_angles_or_tag) + "");
			#/
			v_pos = v_origin_or_ent gettagorigin(v_angles_or_tag);
			v_ang = v_origin_or_ent gettagangles(v_angles_or_tag);
			if(n_lerp > 0)
			{
				prevorigin = self.origin;
				prevangles = self.angles;
			}
			if(!isdefined(v_pos))
			{
				v_pos = v_origin_or_ent.origin;
				v_ang = v_origin_or_ent.angles;
			}
			if(isactor(self))
			{
				self forceteleport(v_pos, v_ang);
			}
			else
			{
				self.origin = v_pos;
				self.angles = v_ang;
			}
			b_link = 1;
			self linkto(v_origin_or_ent, v_angles_or_tag, (0, 0, 0), (0, 0, 0));
			if(n_lerp > 0)
			{
				if(isactor(self))
				{
					self forceteleport(prevorigin, prevangles);
				}
				else
				{
					self.origin = prevorigin;
					self.angles = prevangles;
				}
			}
			self animscripted(animation, v_pos, v_ang, animation, "normal", undefined, n_rate, n_blend_in, n_lerp, n_start_time, 1, b_show_player_firstperson_weapon);
		}
		else
		{
			v_angles = (isdefined(v_origin_or_ent.angles) ? v_origin_or_ent.angles : (0, 0, 0));
			self animscripted(animation, v_origin_or_ent.origin, v_angles, animation, "normal", undefined, n_rate, n_blend_in, n_lerp, n_start_time, 1, b_show_player_firstperson_weapon);
		}
	}
	if(isplayer(self))
	{
		set_player_clamps();
	}
	/#
		self thread anim_info_render_thread(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp);
	#/
	if(!isanimlooping(animation) && n_blend_out > 0 && n_rate > 0 && n_start_time < 1)
	{
		if(!animhasnotetrack(animation, "start_ragdoll"))
		{
			self thread _blend_out(animation, n_blend_out, n_rate, n_start_time);
		}
	}
	self thread handle_notetracks(animation);
	if(getanimframecount(animation) > 1 || isanimlooping(animation))
	{
		self waittillmatch(animation);
	}
	else
	{
		wait(0.05);
	}
	if(b_link && (isdefined(b_unlink_after_completed) && b_unlink_after_completed))
	{
		self unlink();
	}
	flagsys::clear("scriptedanim");
	flagsys::clear("firstframe");
	/#
		debug_print(animation, "");
	#/
	waittillframeend();
	flagsys::clear("scripted_anim_this_frame");
}

/*
	Name: _blend_out
	Namespace: animation
	Checksum: 0x4BF8531C
	Offset: 0xF30
	Size: 0x11C
	Parameters: 4
	Flags: Linked
*/
function _blend_out(animation, n_blend, n_rate, n_start_time)
{
	self endon(#"death");
	self endon(#"end");
	self endon(#"scriptedanim");
	self endon(#"new_scripted_anim");
	n_server_length = (floor(getanimlength(animation) / 0.05)) * 0.05;
	while(true)
	{
		n_current_time = self getanimtime(animation) * n_server_length;
		n_time_left = n_server_length - n_current_time;
		if(n_time_left <= n_blend)
		{
			self stopanimscripted(n_blend);
			break;
		}
		wait(0.05);
	}
}

/*
	Name: _get_align_ent
	Namespace: animation
	Checksum: 0x97C3831F
	Offset: 0x1058
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function _get_align_ent(e_align)
{
	e = self;
	if(isdefined(e_align))
	{
		e = e_align;
	}
	if(!isdefined(e.angles))
	{
		e.angles = (0, 0, 0);
	}
	return e;
}

/*
	Name: _get_align_pos
	Namespace: animation
	Checksum: 0xBC4CE7CD
	Offset: 0x10C0
	Size: 0x1E0
	Parameters: 2
	Flags: Linked
*/
function _get_align_pos(v_origin_or_ent = self.origin, v_angles_or_tag = (isdefined(self.angles) ? self.angles : (0, 0, 0)))
{
	s = spawnstruct();
	if(isvec(v_origin_or_ent))
	{
		/#
			assert(isvec(v_angles_or_tag), "");
		#/
		s.origin = v_origin_or_ent;
		s.angles = v_angles_or_tag;
	}
	else
	{
		e_align = _get_align_ent(v_origin_or_ent);
		if(isstring(v_angles_or_tag))
		{
			s.origin = e_align gettagorigin(v_angles_or_tag);
			s.angles = e_align gettagangles(v_angles_or_tag);
		}
		else
		{
			s.origin = e_align.origin;
			s.angles = e_align.angles;
		}
	}
	if(!isdefined(s.angles))
	{
		s.angles = (0, 0, 0);
	}
	return s;
}

/*
	Name: teleport
	Namespace: animation
	Checksum: 0x36569C1D
	Offset: 0x12A8
	Size: 0x130
	Parameters: 4
	Flags: None
*/
function teleport(animation, v_origin_or_ent, v_angles_or_tag, time = 0)
{
	s = _get_align_pos(v_origin_or_ent, v_angles_or_tag);
	v_pos = getstartorigin(s.origin, s.angles, animation, time);
	v_ang = getstartangles(s.origin, s.angles, animation, time);
	if(isactor(self))
	{
		self forceteleport(v_pos, v_ang);
	}
	else
	{
		self.origin = v_pos;
		self.angles = v_ang;
	}
}

/*
	Name: reach
	Namespace: animation
	Checksum: 0x31E0A4B9
	Offset: 0x13E0
	Size: 0x9A
	Parameters: 4
	Flags: Linked
*/
function reach(animation, v_origin_or_ent, v_angles_or_tag, b_disable_arrivals = 0)
{
	self endon(#"death");
	s_tracker = spawnstruct();
	self thread _reach(s_tracker, animation, v_origin_or_ent, v_angles_or_tag, b_disable_arrivals);
	s_tracker waittill(#"done");
}

/*
	Name: _reach
	Namespace: animation
	Checksum: 0x70F24866
	Offset: 0x1488
	Size: 0x38A
	Parameters: 5
	Flags: Linked
*/
function _reach(s_tracker, animation, v_origin_or_ent, v_angles_or_tag, b_disable_arrivals = 0)
{
	self endon(#"death");
	self notify(#"stop_going_to_node");
	self notify(#"new_anim_reach");
	flagsys::wait_till_clear("anim_reach");
	flagsys::set("anim_reach");
	s = _get_align_pos(v_origin_or_ent, v_angles_or_tag);
	goal = getstartorigin(s.origin, s.angles, animation);
	n_delta = distancesquared(goal, self.origin);
	if(n_delta > 16)
	{
		self stopanimscripted(0.2);
		if(b_disable_arrivals)
		{
			if(ai::has_behavior_attribute("disablearrivals"))
			{
				ai::set_behavior_attribute("disablearrivals", 1);
			}
			self.stopanimdistsq = 0.0001;
		}
		if(isdefined(self.archetype) && self.archetype == "robot")
		{
			ai::set_behavior_attribute("rogue_control_force_goal", goal);
		}
		else if(ai::has_behavior_attribute("vignette_mode") && (!(isdefined(self.ignorevignettemodeforanimreach) && self.ignorevignettemodeforanimreach)))
		{
			ai::set_behavior_attribute("vignette_mode", "fast");
		}
		self thread ai::force_goal(goal, 15, 1, undefined, 0, 1);
		/#
			self thread debug_anim_reach();
		#/
		self util::waittill_any("goal", "new_anim_reach", "new_scripted_anim", "stop_scripted_anim");
		if(ai::has_behavior_attribute("disablearrivals"))
		{
			ai::set_behavior_attribute("disablearrivals", 0);
			self.stopanimdistsq = 0;
		}
	}
	else
	{
		waittillframeend();
	}
	if(!(isdefined(self.archetype) && self.archetype == "robot") && ai::has_behavior_attribute("vignette_mode"))
	{
		ai::set_behavior_attribute("vignette_mode", "off");
	}
	flagsys::clear("anim_reach");
	s_tracker notify(#"done");
	self notify(#"reach_done");
}

/*
	Name: debug_anim_reach
	Namespace: animation
	Checksum: 0x1742E918
	Offset: 0x1820
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function debug_anim_reach()
{
	/#
		self endon(#"death");
		self endon(#"goal");
		self endon(#"new_anim_reach");
		self endon(#"new_scripted_anim");
		self endon(#"stop_scripted_anim");
		while(true)
		{
			level flagsys::wait_till("");
			print3d(self.origin, "", (1, 0, 0), 1, 1, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: set_death_anim
	Namespace: animation
	Checksum: 0x18C31A4B
	Offset: 0x18C8
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function set_death_anim(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp)
{
	self notify(#"new_death_anim");
	if(isdefined(animation))
	{
		self.skipdeath = 1;
		self thread _do_death_anim(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp);
	}
	else
	{
		self.skipdeath = 0;
	}
}

/*
	Name: _do_death_anim
	Namespace: animation
	Checksum: 0x8D6E5745
	Offset: 0x1978
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function _do_death_anim(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp)
{
	self endon(#"new_death_anim");
	self waittill(#"death");
	if(isdefined(self) && !self isragdoll())
	{
		self play(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp);
	}
}

/*
	Name: set_player_clamps
	Namespace: animation
	Checksum: 0xD759F501
	Offset: 0x1A30
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function set_player_clamps()
{
	if(isdefined(self.player_anim_look_enabled) && self.player_anim_look_enabled)
	{
		self setviewclamp(self.player_anim_clamp_right, self.player_anim_clamp_left, self.player_anim_clamp_top, self.player_anim_clamp_bottom);
	}
}

/*
	Name: add_notetrack_func
	Namespace: animation
	Checksum: 0xEC189A20
	Offset: 0x1A88
	Size: 0x6E
	Parameters: 2
	Flags: Linked
*/
function add_notetrack_func(funcname, func)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		level._animnotifyfuncs = [];
	}
	/#
		assert(!isdefined(level._animnotifyfuncs[funcname]), "");
	#/
	level._animnotifyfuncs[funcname] = func;
}

/*
	Name: add_global_notetrack_handler
	Namespace: animation
	Checksum: 0x2D08F2B6
	Offset: 0x1B00
	Size: 0x114
	Parameters: 4
	Flags: Linked, Variadic
*/
function add_global_notetrack_handler(str_note, func, pass_notify_params, ...)
{
	if(!isdefined(level._animnotetrackhandlers))
	{
		level._animnotetrackhandlers = [];
	}
	if(!isdefined(level._animnotetrackhandlers[str_note]))
	{
		level._animnotetrackhandlers[str_note] = [];
	}
	if(!isdefined(level._animnotetrackhandlers[str_note]))
	{
		level._animnotetrackhandlers[str_note] = [];
	}
	else if(!isarray(level._animnotetrackhandlers[str_note]))
	{
		level._animnotetrackhandlers[str_note] = array(level._animnotetrackhandlers[str_note]);
	}
	level._animnotetrackhandlers[str_note][level._animnotetrackhandlers[str_note].size] = array(func, pass_notify_params, vararg);
}

/*
	Name: call_notetrack_handler
	Namespace: animation
	Checksum: 0x3CC8DBF9
	Offset: 0x1C20
	Size: 0x2C0
	Parameters: 3
	Flags: Linked
*/
function call_notetrack_handler(str_note, param1, param2)
{
	if(isdefined(level._animnotetrackhandlers[str_note]))
	{
		foreach(handler in level._animnotetrackhandlers[str_note])
		{
			func = handler[0];
			passnotifyparams = handler[1];
			args = handler[2];
			if(passnotifyparams)
			{
				self [[func]](param1, param2);
				continue;
			}
			switch(args.size)
			{
				case 6:
				{
					self [[func]](args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				}
				case 5:
				{
					self [[func]](args[0], args[1], args[2], args[3], args[4]);
					break;
				}
				case 4:
				{
					self [[func]](args[0], args[1], args[2], args[3]);
					break;
				}
				case 3:
				{
					self [[func]](args[0], args[1], args[2]);
					break;
				}
				case 2:
				{
					self [[func]](args[0], args[1]);
					break;
				}
				case 1:
				{
					self [[func]](args[0]);
					break;
				}
				case 0:
				{
					self [[func]]();
					break;
				}
				default:
				{
					/#
						assertmsg("");
					#/
				}
			}
		}
	}
}

/*
	Name: setup_notetracks
	Namespace: animation
	Checksum: 0x556D1E43
	Offset: 0x1EE8
	Size: 0x3C4
	Parameters: 0
	Flags: Linked
*/
function setup_notetracks()
{
	add_notetrack_func("flag::set", &flag::set);
	add_notetrack_func("flag::clear", &flag::clear);
	add_notetrack_func("util::break_glass", &util::break_glass);
	clientfield::register("scriptmover", "cracks_on", 1, getminbitcountfornum(4), "int");
	clientfield::register("scriptmover", "cracks_off", 1, getminbitcountfornum(4), "int");
	add_global_notetrack_handler("red_cracks_on", &cracks_on, 0, "red");
	add_global_notetrack_handler("green_cracks_on", &cracks_on, 0, "green");
	add_global_notetrack_handler("blue_cracks_on", &cracks_on, 0, "blue");
	add_global_notetrack_handler("all_cracks_on", &cracks_on, 0, "all");
	add_global_notetrack_handler("red_cracks_off", &cracks_off, 0, "red");
	add_global_notetrack_handler("green_cracks_off", &cracks_off, 0, "green");
	add_global_notetrack_handler("blue_cracks_off", &cracks_off, 0, "blue");
	add_global_notetrack_handler("all_cracks_off", &cracks_off, 0, "all");
	add_global_notetrack_handler("headlook_on", &enable_headlook, 0, 1);
	add_global_notetrack_handler("headlook_off", &enable_headlook, 0, 0);
	add_global_notetrack_handler("headlook_notorso_on", &enable_headlook_notorso, 0, 1);
	add_global_notetrack_handler("headlook_notorso_off", &enable_headlook_notorso, 0, 0);
	add_global_notetrack_handler("attach weapon", &attach_weapon, 1);
	add_global_notetrack_handler("detach weapon", &detach_weapon, 1);
	add_global_notetrack_handler("fire", &fire_weapon, 0);
}

/*
	Name: handle_notetracks
	Namespace: animation
	Checksum: 0xF752A967
	Offset: 0x22B8
	Size: 0xAE
	Parameters: 1
	Flags: Linked
*/
function handle_notetracks(animation)
{
	self endon(#"death");
	self endon(#"new_scripted_anim");
	while(true)
	{
		self waittill(animation, str_note, param1, param2);
		if(isdefined(str_note))
		{
			if(str_note != "end" && str_note != "loop_end")
			{
				self thread call_notetrack_handler(str_note, param1, param2);
			}
			else
			{
				return;
			}
		}
	}
}

/*
	Name: cracks_on
	Namespace: animation
	Checksum: 0x2E1BD77
	Offset: 0x2370
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function cracks_on(str_type)
{
	switch(str_type)
	{
		case "red":
		{
			clientfield::set("cracks_on", 1);
			break;
		}
		case "green":
		{
			clientfield::set("cracks_on", 3);
			break;
		}
		case "blue":
		{
			clientfield::set("cracks_on", 2);
			break;
		}
		case "all":
		{
			clientfield::set("cracks_on", 4);
			break;
		}
	}
}

/*
	Name: cracks_off
	Namespace: animation
	Checksum: 0x6CC90107
	Offset: 0x2438
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function cracks_off(str_type)
{
	switch(str_type)
	{
		case "red":
		{
			clientfield::set("cracks_off", 1);
			break;
		}
		case "green":
		{
			clientfield::set("cracks_off", 3);
			break;
		}
		case "blue":
		{
			clientfield::set("cracks_off", 2);
			break;
		}
		case "all":
		{
			clientfield::set("cracks_off", 4);
			break;
		}
	}
}

/*
	Name: enable_headlook
	Namespace: animation
	Checksum: 0x6AF61482
	Offset: 0x2500
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function enable_headlook(b_on = 1)
{
	if(isactor(self))
	{
		if(b_on)
		{
			self lookatentity(level.players[0]);
		}
		else
		{
			self lookatentity();
		}
	}
}

/*
	Name: enable_headlook_notorso
	Namespace: animation
	Checksum: 0x7D5F3A16
	Offset: 0x2580
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function enable_headlook_notorso(b_on = 1)
{
	if(isactor(self))
	{
		if(b_on)
		{
			self lookatentity(level.players[0], 1);
		}
		else
		{
			self lookatentity();
		}
	}
}

/*
	Name: is_valid_weapon
	Namespace: animation
	Checksum: 0xBC9C7BD3
	Offset: 0x2608
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function is_valid_weapon(weaponobject)
{
	return isdefined(weaponobject) && weaponobject != level.weaponnone;
}

/*
	Name: attach_weapon
	Namespace: animation
	Checksum: 0x8BBE9CE2
	Offset: 0x2638
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function attach_weapon(weaponobject, tag = "tag_weapon_right")
{
	if(isactor(self))
	{
		if(is_valid_weapon(weaponobject))
		{
			ai::gun_switchto(weaponobject.name, "right");
		}
		else
		{
			ai::gun_recall();
		}
	}
	else
	{
		if(!is_valid_weapon(weaponobject))
		{
			weaponobject = self.last_item;
		}
		if(is_valid_weapon(weaponobject))
		{
			if(self.item != level.weaponnone)
			{
				detach_weapon();
			}
			/#
				assert(isdefined(weaponobject.worldmodel));
			#/
			self attach(weaponobject.worldmodel, tag);
			self setentityweapon(weaponobject);
			self.gun_removed = undefined;
			self.last_item = weaponobject;
		}
	}
}

/*
	Name: detach_weapon
	Namespace: animation
	Checksum: 0x9D60CE26
	Offset: 0x27C8
	Size: 0xF0
	Parameters: 2
	Flags: Linked
*/
function detach_weapon(weaponobject, tag = "tag_weapon_right")
{
	if(isactor(self))
	{
		ai::gun_remove();
	}
	else
	{
		if(!is_valid_weapon(weaponobject))
		{
			weaponobject = self.item;
		}
		if(is_valid_weapon(weaponobject))
		{
			self detach(weaponobject.worldmodel, tag);
			self setentityweapon(level.weaponnone);
		}
		self.gun_removed = 1;
	}
}

/*
	Name: fire_weapon
	Namespace: animation
	Checksum: 0x54543657
	Offset: 0x28C0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function fire_weapon()
{
	if(!isai(self))
	{
		if(self.item != level.weaponnone)
		{
			startpos = self gettagorigin("tag_flash");
			endpos = startpos + vectorscale(anglestoforward(self gettagangles("tag_flash")), 100);
			magicbullet(self.item, startpos, endpos, self);
		}
	}
}

