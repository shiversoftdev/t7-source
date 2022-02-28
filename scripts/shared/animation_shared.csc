// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\animation_debug_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\shaderanim_shared;
#using scripts\shared\system_shared;

#namespace animation;

/*
	Name: __init__sytem__
	Namespace: animation
	Checksum: 0xE0AC7F5E
	Offset: 0x348
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
	Checksum: 0x25DA405
	Offset: 0x388
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "cracks_on", 1, getminbitcountfornum(4), "int", &cf_cracks_on, 0, 0);
	clientfield::register("scriptmover", "cracks_off", 1, getminbitcountfornum(4), "int", &cf_cracks_off, 0, 0);
	setup_notetracks();
}

/*
	Name: first_frame
	Namespace: animation
	Checksum: 0x311D4031
	Offset: 0x458
	Size: 0x3C
	Parameters: 3
	Flags: None
*/
function first_frame(animation, v_origin_or_ent, v_angles_or_tag)
{
	self thread play(animation, v_origin_or_ent, v_angles_or_tag, 0);
}

/*
	Name: play
	Namespace: animation
	Checksum: 0xDF4D2215
	Offset: 0x4A0
	Size: 0xE8
	Parameters: 8
	Flags: Linked
*/
function play(animation, v_origin_or_ent, v_angles_or_tag, n_rate = 1, n_blend_in = 0.2, n_blend_out = 0.2, n_lerp, b_link = 0)
{
	self endon(#"entityshutdown");
	self thread _play(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp, b_link);
	self waittill(#"scriptedanim");
}

/*
	Name: _play
	Namespace: animation
	Checksum: 0x5831FC01
	Offset: 0x590
	Size: 0x3F4
	Parameters: 8
	Flags: Linked
*/
function _play(animation, v_origin_or_ent = self, v_angles_or_tag, n_rate = 1, n_blend_in = 0.2, n_blend_out = 0.2, n_lerp, b_link = 0)
{
	self endon(#"entityshutdown");
	self notify(#"new_scripted_anim");
	self endon(#"new_scripted_anim");
	flagsys::set_val("firstframe", n_rate == 0);
	flagsys::set("scripted_anim_this_frame");
	flagsys::set("scriptedanim");
	if(isvec(v_origin_or_ent) && isvec(v_angles_or_tag))
	{
		self animscripted("_anim_notify_", v_origin_or_ent, v_angles_or_tag, animation, n_blend_in, n_rate);
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
			self.origin = v_pos;
			self.angles = v_ang;
			b_link = 1;
			self animscripted("_anim_notify_", self.origin, self.angles, animation, n_blend_in, n_rate);
		}
		else
		{
			v_angles = (isdefined(v_origin_or_ent.angles) ? v_origin_or_ent.angles : (0, 0, 0));
			self animscripted("_anim_notify_", v_origin_or_ent.origin, v_angles, animation, n_blend_in, n_rate);
		}
	}
	if(!b_link)
	{
		self unlink();
	}
	/#
		self thread anim_info_render_thread(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp);
	#/
	self thread handle_notetracks();
	self waittill_end();
	if(b_link)
	{
		self unlink();
	}
	flagsys::clear("scriptedanim");
	flagsys::clear("firstframe");
	waittillframeend();
	flagsys::clear("scripted_anim_this_frame");
}

/*
	Name: waittill_end
	Namespace: animation
	Checksum: 0xC638E379
	Offset: 0x990
	Size: 0x26
	Parameters: 0
	Flags: Linked, Private
*/
function private waittill_end()
{
	level endon(#"demo_jump");
	self waittillmatch(#"_anim_notify_");
}

/*
	Name: _get_align_ent
	Namespace: animation
	Checksum: 0xA063394E
	Offset: 0x9C0
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
	Checksum: 0x60BFAEE6
	Offset: 0xA28
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
	Name: play_siege
	Namespace: animation
	Checksum: 0x4B654A82
	Offset: 0xC10
	Size: 0x158
	Parameters: 4
	Flags: Linked
*/
function play_siege(str_anim, str_shot = "default", n_rate = 1, b_loop = 0)
{
	level endon(#"demo_jump");
	self endon(#"entityshutdown");
	if(n_rate == 0)
	{
		self siegecmd("set_anim", str_anim, "set_shot", str_shot, "pause", "goto_start");
	}
	else
	{
		self siegecmd("set_anim", str_anim, "set_shot", str_shot, "unpause", "set_playback_speed", n_rate, "send_end_events", 1, (b_loop ? "loop" : "unloop"));
	}
	self waittill(#"end");
}

/*
	Name: add_notetrack_func
	Namespace: animation
	Checksum: 0xBDC28941
	Offset: 0xD70
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
	Checksum: 0xA1D627FB
	Offset: 0xDE8
	Size: 0x104
	Parameters: 3
	Flags: Linked, Variadic
*/
function add_global_notetrack_handler(str_note, func, ...)
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
	level._animnotetrackhandlers[str_note][level._animnotetrackhandlers[str_note].size] = array(func, vararg);
}

/*
	Name: call_notetrack_handler
	Namespace: animation
	Checksum: 0xE356F2BC
	Offset: 0xEF8
	Size: 0x280
	Parameters: 1
	Flags: Linked
*/
function call_notetrack_handler(str_note)
{
	if(isdefined(level._animnotetrackhandlers) && isdefined(level._animnotetrackhandlers[str_note]))
	{
		foreach(handler in level._animnotetrackhandlers[str_note])
		{
			func = handler[0];
			args = handler[1];
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
	Checksum: 0x17B050D
	Offset: 0x1180
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function setup_notetracks()
{
	add_notetrack_func("flag::set", &flag::set);
	add_notetrack_func("flag::clear", &flag::clear);
	add_notetrack_func("postfx::PlayPostFxBundle", &postfx::playpostfxbundle);
	add_notetrack_func("postfx::StopPostFxBundle", &postfx::stoppostfxbundle);
	add_global_notetrack_handler("red_cracks_on", &cracks_on, "red");
	add_global_notetrack_handler("green_cracks_on", &cracks_on, "green");
	add_global_notetrack_handler("blue_cracks_on", &cracks_on, "blue");
	add_global_notetrack_handler("all_cracks_on", &cracks_on, "all");
	add_global_notetrack_handler("red_cracks_off", &cracks_off, "red");
	add_global_notetrack_handler("green_cracks_off", &cracks_off, "green");
	add_global_notetrack_handler("blue_cracks_off", &cracks_off, "blue");
	add_global_notetrack_handler("all_cracks_off", &cracks_off, "all");
}

/*
	Name: handle_notetracks
	Namespace: animation
	Checksum: 0x85FA08C8
	Offset: 0x13B0
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function handle_notetracks()
{
	level endon(#"demo_jump");
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"_anim_notify_", str_note);
		if(str_note != "end" && str_note != "loop_end")
		{
			self thread call_notetrack_handler(str_note);
		}
		else
		{
			return;
		}
	}
}

/*
	Name: cracks_on
	Namespace: animation
	Checksum: 0x1E682765
	Offset: 0x1438
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
			cf_cracks_on(self.localclientnum, 0, 1);
			break;
		}
		case "green":
		{
			cf_cracks_on(self.localclientnum, 0, 3);
			break;
		}
		case "blue":
		{
			cf_cracks_on(self.localclientnum, 0, 2);
			break;
		}
		case "all":
		{
			cf_cracks_on(self.localclientnum, 0, 4);
			break;
		}
	}
}

/*
	Name: cracks_off
	Namespace: animation
	Checksum: 0xB65B2C21
	Offset: 0x1500
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
			cf_cracks_off(self.localclientnum, 0, 1);
			break;
		}
		case "green":
		{
			cf_cracks_off(self.localclientnum, 0, 3);
			break;
		}
		case "blue":
		{
			cf_cracks_off(self.localclientnum, 0, 2);
			break;
		}
		case "all":
		{
			cf_cracks_off(self.localclientnum, 0, 4);
			break;
		}
	}
}

/*
	Name: cf_cracks_on
	Namespace: animation
	Checksum: 0xBDEE7454
	Offset: 0x15C8
	Size: 0x192
	Parameters: 7
	Flags: Linked
*/
function cf_cracks_on(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 1:
		{
			shaderanim::animate_crack(localclientnum, "scriptVector1", 0, 3, 0, 1);
			break;
		}
		case 3:
		{
			shaderanim::animate_crack(localclientnum, "scriptVector2", 0, 3, 0, 1);
			break;
		}
		case 2:
		{
			shaderanim::animate_crack(localclientnum, "scriptVector3", 0, 3, 0, 1);
			break;
		}
		case 4:
		{
			shaderanim::animate_crack(localclientnum, "scriptVector1", 0, 3, 0, 1);
			shaderanim::animate_crack(localclientnum, "scriptVector2", 0, 3, 0, 1);
			shaderanim::animate_crack(localclientnum, "scriptVector3", 0, 3, 0, 1);
		}
	}
}

/*
	Name: cf_cracks_off
	Namespace: animation
	Checksum: 0xA1D888F6
	Offset: 0x1768
	Size: 0x17A
	Parameters: 7
	Flags: Linked
*/
function cf_cracks_off(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 1:
		{
			shaderanim::animate_crack(localclientnum, "scriptVector1", 0, 0, 1, 0);
			break;
		}
		case 3:
		{
			shaderanim::animate_crack(localclientnum, "scriptVector2", 0, 0, 1, 0);
			break;
		}
		case 2:
		{
			shaderanim::animate_crack(localclientnum, "scriptVector3", 0, 0, 1, 0);
			break;
		}
		case 4:
		{
			shaderanim::animate_crack(localclientnum, "scriptVector1", 0, 0, 1, 0);
			shaderanim::animate_crack(localclientnum, "scriptVector2", 0, 0, 1, 0);
			shaderanim::animate_crack(localclientnum, "scriptVector3", 0, 0, 1, 0);
		}
	}
}

