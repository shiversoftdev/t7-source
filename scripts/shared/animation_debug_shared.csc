// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\animation_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace animation;

/*
	Name: __init__
	Namespace: animation
	Checksum: 0x2D796748
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
	Checksum: 0x4CE08CAD
	Offset: 0x1B8
	Size: 0x4C0
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
		while(true)
		{
			level flagsys::wait_till("");
			_init_frame();
			str_extra_info = "";
			color = (0, 1, 1);
			if(flagsys::get(""))
			{
				str_extra_info = str_extra_info + "";
			}
			s_pos = _get_align_pos(v_origin_or_ent, v_angles_or_tag);
			self anim_origin_render(s_pos.origin, s_pos.angles);
			line(self.origin, s_pos.origin, color, 0.5, 1);
			sphere(s_pos.origin, 2, vectorscale((1, 1, 1), 0.3), 0.5, 1);
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
				print3d(v_origin_or_ent.origin + vectorscale((0, 0, 1), 5), str_name, vectorscale((1, 1, 1), 0.3), 1, 0.15);
			}
			self anim_origin_render(self.origin, self.angles);
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
			print3d(self.origin, ((self getentnum() + get_ent_type()) + "") + str_name, color, 0.8, 0.3);
			print3d(self.origin - vectorscale((0, 0, 1), 5), "" + animation, color, 0.8, 0.3);
			print3d(self.origin - vectorscale((0, 0, 1), 7), str_extra_info, color, 0.8, 0.15);
			render_tag("", "");
			render_tag("", "");
			render_tag("", "");
			render_tag("", "");
			_reset_frame();
			wait(0.01);
		}
	#/
}

/*
	Name: get_ent_type
	Namespace: animation
	Checksum: 0xF464E42
	Offset: 0x680
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function get_ent_type()
{
	/#
		return ("" + (isdefined(self.classname) ? self.classname : "")) + "";
	#/
}

/*
	Name: _init_frame
	Namespace: animation
	Checksum: 0x3EDA4064
	Offset: 0x6C8
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function _init_frame()
{
	/#
	#/
}

/*
	Name: _reset_frame
	Namespace: animation
	Checksum: 0xA115834F
	Offset: 0x6D8
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
	Checksum: 0xBA824C8C
	Offset: 0x6F8
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function render_tag(str_tag, str_label)
{
	/#
		if(!isdefined(str_label))
		{
			str_label = str_tag;
		}
		v_tag_org = self gettagorigin(str_tag);
		if(isdefined(v_tag_org))
		{
			v_tag_ang = self gettagangles(str_tag);
			anim_origin_render(v_tag_org, v_tag_ang, 2, str_label);
			if(isdefined(self.v_centroid))
			{
				line(self.v_centroid, v_tag_org, vectorscale((1, 1, 1), 0.3), 0.5, 1);
			}
		}
	#/
}

/*
	Name: anim_origin_render
	Namespace: animation
	Checksum: 0x9D5E1456
	Offset: 0x7E8
	Size: 0x18C
	Parameters: 4
	Flags: Linked
*/
function anim_origin_render(org, angles, line_length, str_label)
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
			line(org, originendpoint, (1, 0, 0));
			line(org, originrightpoint, (0, 1, 0));
			line(org, originuppoint, (0, 0, 1));
			if(isdefined(str_label))
			{
				print3d(org, str_label, (1, 0.7529412, 0.7960784), 1, 0.05);
			}
		}
	#/
}

