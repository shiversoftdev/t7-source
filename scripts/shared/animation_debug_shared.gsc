// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\animation_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace animation;

/*
	Name: __init__
	Namespace: animation
	Checksum: 0x49208920
	Offset: 0xE0
	Size: 0xD0
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__()
{
	/#
		setdvar("", 0);
		setdvar("", 0);
		while(true)
		{
			anim_debug = getdvarint("", 0) || getdvarint("", 0);
			level flagsys::set_val("", anim_debug);
			if(!anim_debug)
			{
				level notify(#"kill_anim_debug");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: anim_info_render_thread
	Namespace: animation
	Checksum: 0xA1BFACD9
	Offset: 0x1B8
	Size: 0x6E8
	Parameters: 7
	Flags: Linked
*/
function anim_info_render_thread(animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp)
{
	/#
		self endon(#"death");
		self endon(#"scriptedanim");
		self notify(#"_anim_info_render_thread_");
		self endon(#"_anim_info_render_thread_");
		if(!isvec(v_origin_or_ent))
		{
			v_origin_or_ent endon(#"death");
		}
		recordent(self);
		while(true)
		{
			level flagsys::wait_till("");
			b_anim_debug_on = 1;
			_init_frame();
			str_extra_info = "";
			color = (1, 1, 0);
			if(flagsys::get(""))
			{
				str_extra_info = str_extra_info + "";
			}
			s_pos = _get_align_pos(v_origin_or_ent, v_angles_or_tag);
			self anim_origin_render(s_pos.origin, s_pos.angles, undefined, undefined, !b_anim_debug_on);
			if(b_anim_debug_on)
			{
				line(self.origin, s_pos.origin, color, 0.5, 1);
				sphere(s_pos.origin, 2, vectorscale((1, 1, 1), 0.3), 0.5, 1);
			}
			recordline(self.origin, s_pos.origin, color, "");
			recordsphere(s_pos.origin, 2, vectorscale((1, 1, 1), 0.3), "");
			if(!isvec(v_origin_or_ent) && (v_origin_or_ent != self && v_origin_or_ent != level))
			{
				str_name = "";
				if(isdefined(v_origin_or_ent.animname))
				{
					str_name = v_origin_or_ent.animname;
				}
				else if(isdefined(v_origin_or_ent.targetname))
				{
					str_name = v_origin_or_ent.targetname;
				}
				if(b_anim_debug_on)
				{
					print3d(v_origin_or_ent.origin + vectorscale((0, 0, 1), 5), str_name, vectorscale((1, 1, 1), 0.3), 1, 0.15);
				}
				record3dtext(str_name, v_origin_or_ent.origin + vectorscale((0, 0, 1), 5), vectorscale((1, 1, 1), 0.3), "");
			}
			self anim_origin_render(self.origin, self.angles, undefined, undefined, !b_anim_debug_on);
			str_name = "";
			if(isdefined(self.anim_debug_name))
			{
				str_name = self.anim_debug_name;
			}
			else
			{
				if(isdefined(self.animname))
				{
					str_name = self.animname;
				}
				else if(isdefined(self.targetname))
				{
					str_name = self.targetname;
				}
			}
			if(b_anim_debug_on)
			{
				print3d(self.origin, ((self getentnum() + get_ent_type()) + "") + str_name, color, 0.8, 0.3);
				print3d(self.origin - vectorscale((0, 0, 1), 5), "" + animation, color, 0.8, 0.3);
				print3d(self.origin - vectorscale((0, 0, 1), 7), str_extra_info, color, 0.8, 0.15);
			}
			record3dtext(((self getentnum() + get_ent_type()) + "") + str_name, self.origin, color, "");
			record3dtext("" + animation, self.origin - vectorscale((0, 0, 1), 5), color, "");
			record3dtext(str_extra_info, self.origin - vectorscale((0, 0, 1), 7), color, "");
			render_tag("", "", !b_anim_debug_on);
			render_tag("", "", !b_anim_debug_on);
			render_tag("", "", !b_anim_debug_on);
			render_tag("", "", !b_anim_debug_on);
			_reset_frame();
			wait(0.05);
		}
	#/
}

/*
	Name: get_ent_type
	Namespace: animation
	Checksum: 0x559085F3
	Offset: 0x8A8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function get_ent_type()
{
	/#
		if(isactor(self))
		{
			return "";
		}
		if(isvehicle(self))
		{
			return "";
		}
		return ("" + self.classname) + "";
	#/
}

/*
	Name: _init_frame
	Namespace: animation
	Checksum: 0x4681CB72
	Offset: 0x920
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function _init_frame()
{
	/#
		self.v_centroid = self getcentroid();
	#/
}

/*
	Name: _reset_frame
	Namespace: animation
	Checksum: 0x5C8339B3
	Offset: 0x950
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function _reset_frame()
{
	/#
		self.v_centroid = undefined;
	#/
}

/*
	Name: render_tag
	Namespace: animation
	Checksum: 0xA930CFB8
	Offset: 0x970
	Size: 0x144
	Parameters: 3
	Flags: Linked
*/
function render_tag(str_tag, str_label, b_recorder_only)
{
	/#
		if(!isdefined(str_label))
		{
			str_label = str_tag;
		}
		if(!isdefined(self.v_centroid))
		{
			self.v_centroid = self getcentroid();
		}
		v_tag_org = self gettagorigin(str_tag);
		if(isdefined(v_tag_org))
		{
			v_tag_ang = self gettagangles(str_tag);
			anim_origin_render(v_tag_org, v_tag_ang, 2, str_label, b_recorder_only);
			if(!b_recorder_only)
			{
				line(self.v_centroid, v_tag_org, vectorscale((1, 1, 1), 0.3), 0.5, 1);
			}
			recordline(self.v_centroid, v_tag_org, vectorscale((1, 1, 1), 0.3), "");
		}
	#/
}

/*
	Name: anim_origin_render
	Namespace: animation
	Checksum: 0xE0C0BA68
	Offset: 0xAC0
	Size: 0x25C
	Parameters: 5
	Flags: Linked
*/
function anim_origin_render(org, angles, line_length, str_label, b_recorder_only)
{
	/#
		if(!isdefined(line_length))
		{
			line_length = 6;
		}
		if(isdefined(org) && isdefined(angles))
		{
			originendpoint = org + vectorscale(anglestoforward(angles), line_length);
			originrightpoint = org + (vectorscale(anglestoright(angles), -1 * line_length));
			originuppoint = org + vectorscale(anglestoup(angles), line_length);
			if(!b_recorder_only)
			{
				line(org, originendpoint, (1, 0, 0));
				line(org, originrightpoint, (0, 1, 0));
				line(org, originuppoint, (0, 0, 1));
			}
			recordline(org, originendpoint, (1, 0, 0), "");
			recordline(org, originrightpoint, (0, 1, 0), "");
			recordline(org, originuppoint, (0, 0, 1), "");
			if(isdefined(str_label))
			{
				if(!b_recorder_only)
				{
					print3d(org, str_label, (1, 0.7529412, 0.7960784), 1, 0.05);
				}
				record3dtext(str_label, org, (1, 0.7529412, 0.7960784), "");
			}
		}
	#/
}

