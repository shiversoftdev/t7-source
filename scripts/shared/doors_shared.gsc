// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

class cdoor 
{
	var m_door_open_delay_time;
	var m_override_swing_angle;
	var m_s_bundle;
	var m_n_door_connect_paths;
	var m_e_door;
	var m_v_open_pos;
	var m_v_close_pos;
	var m_str_script_flag;
	var m_str_target;
	var m_n_trigger_height;
	var m_e_trigger;
	var m_e_hint_trigger;
	var m_e_trigger_player;

	/*
		Name: constructor
		Namespace: cdoor
		Checksum: 0x9F3F54B6
		Offset: 0x230
		Size: 0x34
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		m_n_trigger_height = 80;
		m_override_swing_angle = undefined;
		m_door_open_delay_time = 0;
		m_e_trigger_player = undefined;
	}

	/*
		Name: destructor
		Namespace: cdoor
		Checksum: 0x8DA9AEA7
		Offset: 0x270
		Size: 0x2C
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
		if(isdefined(m_e_trigger))
		{
			m_e_trigger delete();
		}
	}

	/*
		Name: setdooropendelay
		Namespace: cdoor
		Checksum: 0x4509FF20
		Offset: 0x1958
		Size: 0x18
		Parameters: 1
		Flags: Linked
	*/
	function setdooropendelay(delay_time)
	{
		m_door_open_delay_time = delay_time;
	}

	/*
		Name: getswingangle
		Namespace: cdoor
		Checksum: 0x4659AA50
		Offset: 0x1910
		Size: 0x40
		Parameters: 0
		Flags: Linked
	*/
	function getswingangle()
	{
		if(isdefined(m_override_swing_angle))
		{
			angle = m_override_swing_angle;
		}
		else
		{
			angle = m_s_bundle.door_swing_angle;
		}
		return angle;
	}

	/*
		Name: set_swing_angle
		Namespace: cdoor
		Checksum: 0x743EE8A4
		Offset: 0x18F0
		Size: 0x18
		Parameters: 1
		Flags: Linked
	*/
	function set_swing_angle(angle)
	{
		m_override_swing_angle = angle;
	}

	/*
		Name: calculate_offset_position
		Namespace: cdoor
		Checksum: 0x6DA45DE7
		Offset: 0x17D0
		Size: 0x118
		Parameters: 3
		Flags: Linked
	*/
	function calculate_offset_position(v_origin, v_angles, v_offset)
	{
		v_pos = v_origin;
		if(v_offset[0])
		{
			v_side = anglestoforward(v_angles);
			v_pos = v_pos + (v_offset[0] * v_side);
		}
		if(v_offset[1])
		{
			v_dir = anglestoright(v_angles);
			v_pos = v_pos + (v_offset[1] * v_dir);
		}
		if(v_offset[2])
		{
			v_up = anglestoup(v_angles);
			v_pos = v_pos + (v_offset[2] * v_up);
		}
		return v_pos;
	}

	/*
		Name: set_door_paths
		Namespace: cdoor
		Checksum: 0x53EBB206
		Offset: 0x17B0
		Size: 0x18
		Parameters: 1
		Flags: Linked
	*/
	function set_door_paths(n_door_connect_paths)
	{
		m_n_door_connect_paths = n_door_connect_paths;
	}

	/*
		Name: init_movement
		Namespace: cdoor
		Checksum: 0x483A0BAE
		Offset: 0x16E8
		Size: 0xBC
		Parameters: 2
		Flags: Linked
	*/
	function init_movement(n_slide_up, n_slide_amount)
	{
		if(m_s_bundle.door_open_method == "slide")
		{
			if(n_slide_up)
			{
				v_offset = (0, 0, n_slide_amount);
			}
			else
			{
				v_offset = (n_slide_amount, 0, 0);
			}
			m_v_open_pos = calculate_offset_position(m_e_door.origin, m_e_door.angles, v_offset);
			m_v_close_pos = m_e_door.origin;
		}
	}

	/*
		Name: set_script_flags
		Namespace: cdoor
		Checksum: 0x9BE49C60
		Offset: 0x15E0
		Size: 0xFA
		Parameters: 1
		Flags: Linked
	*/
	function set_script_flags(b_set)
	{
		if(isdefined(m_str_script_flag))
		{
			a_flags = strtok(m_str_script_flag, ",");
			foreach(str_flag in a_flags)
			{
				if(b_set)
				{
					level flag::set(str_flag);
					continue;
				}
				level flag::clear(str_flag);
			}
		}
	}

	/*
		Name: init_trigger
		Namespace: cdoor
		Checksum: 0xBB002632
		Offset: 0x13C8
		Size: 0x20C
		Parameters: 2
		Flags: Linked
	*/
	function init_trigger(v_offset, n_radius)
	{
		v_pos = calculate_offset_position(m_e_door.origin, m_e_door.angles, v_offset);
		v_pos = (v_pos[0], v_pos[1], v_pos[2] + 50);
		if(isdefined(m_s_bundle.door_trigger_at_target) && m_s_bundle.door_trigger_at_target)
		{
			e_target = getent(m_str_target, "targetname");
			if(isdefined(e_target))
			{
				v_pos = e_target.origin;
			}
		}
		if(isdefined(m_s_bundle.door_use_trigger) && m_s_bundle.door_use_trigger)
		{
			m_e_trigger = spawn("trigger_radius_use", v_pos, 0, n_radius, m_n_trigger_height);
			m_e_trigger triggerignoreteam();
			m_e_trigger setvisibletoall();
			m_e_trigger setteamfortrigger("none");
			m_e_trigger usetriggerrequirelookat();
			m_e_trigger setcursorhint("HINT_NOICON");
		}
		else
		{
			m_e_trigger = spawn("trigger_radius", v_pos, 0, n_radius, m_n_trigger_height);
		}
	}

	/*
		Name: process_hint_trigger_message
		Namespace: cdoor
		Checksum: 0xAD8CDF04
		Offset: 0x1240
		Size: 0x180
		Parameters: 0
		Flags: Linked
	*/
	function process_hint_trigger_message()
	{
		str_hint = "";
		if(isdefined(m_s_bundle.door_trigger_at_target) && m_s_bundle.door_trigger_at_target)
		{
			str_hint = "This door is controlled elsewhere";
		}
		else if(m_s_bundle.door_unlock_method == "hack")
		{
			str_hint = "This door is electronically locked";
		}
		while(true)
		{
			m_e_hint_trigger sethintstring(str_hint);
			if(isdefined(m_s_bundle.door_trigger_at_target) && m_s_bundle.door_trigger_at_target)
			{
				self flag::wait_till("open");
			}
			else
			{
				self flag::wait_till_clear("locked");
			}
			m_e_hint_trigger sethintstring("");
			if(isdefined(m_s_bundle.door_trigger_at_target) && m_s_bundle.door_trigger_at_target)
			{
				self flag::wait_till_clear("open");
			}
			else
			{
				self flag::wait_till("locked");
			}
		}
	}

	/*
		Name: run_lock_fx
		Namespace: cdoor
		Checksum: 0x27951F73
		Offset: 0x1000
		Size: 0x238
		Parameters: 0
		Flags: Linked
	*/
	function run_lock_fx()
	{
		if(!isdefined(m_s_bundle.door_locked_fx) && !isdefined(m_s_bundle.door_unlocked_fx))
		{
			return;
		}
		e_fx = undefined;
		v_pos = get_hack_pos();
		v_angles = get_hack_angles();
		while(true)
		{
			self flag::wait_till("locked");
			if(isdefined(e_fx))
			{
				e_fx delete();
				e_fx = undefined;
			}
			if(isdefined(m_s_bundle.door_locked_fx))
			{
				e_fx = spawn("script_model", v_pos);
				e_fx setmodel("tag_origin");
				e_fx.angles = v_angles;
				playfxontag(m_s_bundle.door_locked_fx, e_fx, "tag_origin");
			}
			self flag::wait_till_clear("locked");
			if(isdefined(e_fx))
			{
				e_fx delete();
				e_fx = undefined;
			}
			if(isdefined(m_s_bundle.door_unlocked_fx))
			{
				e_fx = spawn("script_model", v_pos);
				e_fx setmodel("tag_origin");
				e_fx.angles = v_angles;
				playfxontag(m_s_bundle.door_unlocked_fx, e_fx, "tag_origin");
			}
		}
	}

	/*
		Name: update_use_message
		Namespace: cdoor
		Checksum: 0x80E55F01
		Offset: 0xED0
		Size: 0x122
		Parameters: 0
		Flags: Linked
	*/
	function update_use_message()
	{
		if(!(isdefined(m_s_bundle.door_use_trigger) && m_s_bundle.door_use_trigger))
		{
			return;
		}
		if(self flag::get("open"))
		{
			if(!(isdefined(m_s_bundle.door_closes) && m_s_bundle.door_closes))
			{
			}
		}
		else
		{
			if(isdefined(m_s_bundle.door_open_message) && m_s_bundle.door_open_message != "")
			{
			}
			else
			{
				if(isdefined(m_s_bundle.door_use_hold) && m_s_bundle.door_use_hold)
				{
				}
				else
				{
					if(m_s_bundle.door_unlock_method == "key")
					{
					}
					else if(self flag::get("locked"))
					{
					}
				}
			}
		}
	}

	/*
		Name: open_internal
		Namespace: cdoor
		Checksum: 0xD665CD3
		Offset: 0xB70
		Size: 0x354
		Parameters: 0
		Flags: Linked
	*/
	function open_internal()
	{
		self flag::set("animating");
		m_e_door notify(#"door_opening");
		if(isdefined(m_s_bundle.door_start_sound) && m_s_bundle.door_start_sound != "")
		{
			m_e_door playsound(m_s_bundle.door_start_sound);
		}
		if(isdefined(m_s_bundle.b_loop_sound) && m_s_bundle.b_loop_sound)
		{
			sndent = spawn("script_origin", m_e_door.origin);
			sndent linkto(m_e_door);
			sndent playloopsound(m_s_bundle.door_loop_sound, 1);
		}
		if(m_s_bundle.door_open_method == "slide")
		{
			m_e_door moveto(m_v_open_pos, m_s_bundle.door_open_time);
		}
		else if(m_s_bundle.door_open_method == "swing")
		{
			angle = getswingangle();
			v_angle = (m_e_door.angles[0], m_e_door.angles[1] + angle, m_e_door.angles[2]);
			m_e_door rotateto(v_angle, m_s_bundle.door_open_time);
		}
		if(isdefined(m_n_door_connect_paths) && m_n_door_connect_paths)
		{
			m_e_door connectpaths();
		}
		wait(m_s_bundle.door_open_time);
		if(isdefined(m_s_bundle.b_loop_sound) && m_s_bundle.b_loop_sound)
		{
			sndent delete();
		}
		if(isdefined(m_s_bundle.door_stop_sound) && m_s_bundle.door_stop_sound != "")
		{
			m_e_door playsound(m_s_bundle.door_stop_sound);
		}
		flag::clear("animating");
		set_script_flags(1);
		update_use_message();
	}

	/*
		Name: close
		Namespace: cdoor
		Checksum: 0xFFD4001C
		Offset: 0xB40
		Size: 0x24
		Parameters: 0
		Flags: Linked
	*/
	function close()
	{
		self flag::clear("open");
	}

	/*
		Name: close_internal
		Namespace: cdoor
		Checksum: 0x28AEFD97
		Offset: 0x7D8
		Size: 0x35C
		Parameters: 0
		Flags: Linked
	*/
	function close_internal()
	{
		self flag::clear("open");
		set_script_flags(0);
		self flag::set("animating");
		if(isdefined(m_s_bundle.b_loop_sound) && m_s_bundle.b_loop_sound)
		{
			m_e_door playsound(m_s_bundle.door_start_sound);
			sndent = spawn("script_origin", m_e_door.origin);
			sndent linkto(m_e_door);
			sndent playloopsound(m_s_bundle.door_loop_sound, 1);
		}
		else if(isdefined(m_s_bundle.door_stop_sound) && m_s_bundle.door_stop_sound != "")
		{
			m_e_door playsound(m_s_bundle.door_stop_sound);
		}
		if(m_s_bundle.door_open_method == "slide")
		{
			m_e_door moveto(m_v_close_pos, m_s_bundle.door_open_time);
		}
		else if(m_s_bundle.door_open_method == "swing")
		{
			angle = getswingangle();
			v_angle = (m_e_door.angles[0], m_e_door.angles[1] - angle, m_e_door.angles[2]);
			m_e_door rotateto(v_angle, m_s_bundle.door_open_time);
		}
		wait(m_s_bundle.door_open_time);
		if(isdefined(m_n_door_connect_paths) && m_n_door_connect_paths)
		{
			m_e_door disconnectpaths();
		}
		if(isdefined(m_s_bundle.b_loop_sound) && m_s_bundle.b_loop_sound)
		{
			sndent delete();
			m_e_door playsound(m_s_bundle.door_stop_sound);
		}
		flag::clear("animating");
		update_use_message();
	}

	/*
		Name: open
		Namespace: cdoor
		Checksum: 0x1735149A
		Offset: 0x7A8
		Size: 0x24
		Parameters: 0
		Flags: Linked
	*/
	function open()
	{
		self flag::set("open");
	}

	/*
		Name: delete_door
		Namespace: cdoor
		Checksum: 0x1AAC9C86
		Offset: 0x748
		Size: 0x58
		Parameters: 0
		Flags: Linked
	*/
	function delete_door()
	{
		m_e_door delete();
		m_e_door = undefined;
		if(isdefined(m_e_trigger))
		{
			m_e_trigger delete();
			m_e_trigger = undefined;
		}
	}

	/*
		Name: unlock
		Namespace: cdoor
		Checksum: 0x2A5369BB
		Offset: 0x718
		Size: 0x24
		Parameters: 0
		Flags: Linked
	*/
	function unlock()
	{
		self flag::clear("locked");
	}

	/*
		Name: lock
		Namespace: cdoor
		Checksum: 0xB234477B
		Offset: 0x6D8
		Size: 0x34
		Parameters: 0
		Flags: Linked
	*/
	function lock()
	{
		self flag::set("locked");
		update_use_message();
	}

	/*
		Name: init_hint_trigger
		Namespace: cdoor
		Checksum: 0xEF60C3C9
		Offset: 0x4E0
		Size: 0x1EC
		Parameters: 0
		Flags: Linked
	*/
	function init_hint_trigger()
	{
		if(m_s_bundle.door_unlock_method == "default" && (!(isdefined(m_s_bundle.door_trigger_at_target) && m_s_bundle.door_trigger_at_target)))
		{
			return;
		}
		if(m_s_bundle.door_unlock_method == "key")
		{
			return;
		}
		v_offset = m_s_bundle.v_trigger_offset;
		n_radius = m_s_bundle.door_trigger_radius;
		v_pos = calculate_offset_position(m_e_door.origin, m_e_door.angles, v_offset);
		v_pos = (v_pos[0], v_pos[1], v_pos[2] + 50);
		e_trig = spawn("trigger_radius_use", v_pos, 0, n_radius, m_n_trigger_height);
		e_trig triggerignoreteam();
		e_trig setvisibletoall();
		e_trig setteamfortrigger("none");
		e_trig usetriggerrequirelookat();
		e_trig setcursorhint("HINT_NOICON");
		m_e_hint_trigger = e_trig;
		thread process_hint_trigger_message();
	}

	/*
		Name: get_hack_angles
		Namespace: cdoor
		Checksum: 0x57820E12
		Offset: 0x460
		Size: 0x74
		Parameters: 0
		Flags: Linked
	*/
	function get_hack_angles()
	{
		v_angles = m_e_door.angles;
		if(isdefined(m_str_target))
		{
			e_target = getent(m_str_target, "targetname");
			if(isdefined(e_target))
			{
				return e_target.angles;
			}
		}
		return v_angles;
	}

	/*
		Name: get_hack_pos
		Namespace: cdoor
		Checksum: 0x46E8E6C9
		Offset: 0x370
		Size: 0xE4
		Parameters: 0
		Flags: Linked
	*/
	function get_hack_pos()
	{
		v_trigger_offset = m_s_bundle.v_trigger_offset;
		v_pos = calculate_offset_position(m_e_door.origin, m_e_door.angles, v_trigger_offset);
		v_pos = (v_pos[0], v_pos[1], v_pos[2] + 50);
		if(isdefined(m_str_target))
		{
			e_target = getent(m_str_target, "targetname");
			if(isdefined(e_target))
			{
				return e_target.origin;
			}
		}
		return v_pos;
	}

	/*
		Name: init_xmodel
		Namespace: cdoor
		Checksum: 0x69916EA7
		Offset: 0x2A8
		Size: 0xBC
		Parameters: 4
		Flags: Linked
	*/
	function init_xmodel(str_xmodel = "script_origin", connect_paths, v_origin, v_angles)
	{
		m_e_door = spawn("script_model", v_origin, 1);
		m_e_door setmodel(str_xmodel);
		m_e_door.angles = v_angles;
		if(connect_paths)
		{
			m_e_door disconnectpaths();
		}
	}

}

#namespace doors;

/*
	Name: __init__sytem__
	Namespace: doors
	Checksum: 0xF1DF7E63
	Offset: 0x1E28
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("doors", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: doors
	Checksum: 0x9AE5757F
	Offset: 0x1E68
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	a_doors = struct::get_array("scriptbundle_doors", "classname");
	foreach(s_instance in a_doors)
	{
		c_door = s_instance init();
		if(isdefined(c_door))
		{
			s_instance.c_door = c_door;
		}
	}
}

/*
	Name: init
	Namespace: doors
	Checksum: 0xBDE7E972
	Offset: 0x1F50
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(!isdefined(self.angles))
	{
		self.angles = (0, 0, 0);
	}
	s_door_bundle = level.scriptbundles["doors"][self.scriptbundlename];
	return setup_door_scriptbundle(s_door_bundle, self);
}

/*
	Name: setup_door_scriptbundle
	Namespace: doors
	Checksum: 0xD682492C
	Offset: 0x1FB8
	Size: 0x768
	Parameters: 2
	Flags: Linked
*/
function setup_door_scriptbundle(s_door_bundle, s_door_instance)
{
	c_door = new cdoor();
	c_door flag::init("locked", 0);
	c_door flag::init("open", 0);
	c_door flag::init("animating", 0);
	c_door.m_s_bundle = s_door_bundle;
	c_door.m_str_targetname = s_door_instance.targetname;
	c_door.m_str_target = s_door_instance.target;
	c_door.m_str_script_flag = s_door_instance.script_flag;
	if(c_door.m_s_bundle.door_unlock_method == "key")
	{
		if(isdefined(c_door.m_s_bundle.door_key_model))
		{
			level.door_key_model = c_door.m_s_bundle.door_key_model;
		}
		if(isdefined(c_door.m_s_bundle.door_key_icon))
		{
			level.door_key_icon = c_door.m_s_bundle.door_key_icon;
		}
		if(isdefined(c_door.m_s_bundle.door_key_fx))
		{
			level.door_key_fx = c_door.m_s_bundle.door_key_fx;
		}
	}
	if(c_door.m_s_bundle.door_unlock_method == "hack" && (!(isdefined(level.door_hack_precached) && level.door_hack_precached)))
	{
		level.door_hack_precached = 1;
	}
	str_door_xmodel = c_door.m_s_bundle.model;
	if(isdefined(c_door.m_s_bundle.door_triggeroffsetx))
	{
		n_xoffset = c_door.m_s_bundle.door_triggeroffsetx;
	}
	else
	{
		n_xoffset = 0;
	}
	if(isdefined(c_door.m_s_bundle.door_triggeroffsety))
	{
		n_yoffset = c_door.m_s_bundle.door_triggeroffsety;
	}
	else
	{
		n_yoffset = 0;
	}
	if(isdefined(c_door.m_s_bundle.door_triggeroffsetz))
	{
		n_zoffset = c_door.m_s_bundle.door_triggeroffsetz;
	}
	else
	{
		n_zoffset = 0;
	}
	v_trigger_offset = (n_xoffset, n_yoffset, n_zoffset);
	c_door.m_s_bundle.v_trigger_offset = v_trigger_offset;
	n_trigger_radius = c_door.m_s_bundle.door_trigger_radius;
	if(isdefined(c_door.m_s_bundle.door_slide_horizontal) && c_door.m_s_bundle.door_slide_horizontal)
	{
		n_slide_up = 0;
	}
	else
	{
		n_slide_up = 1;
	}
	n_open_time = c_door.m_s_bundle.door_open_time;
	n_slide_amount = c_door.m_s_bundle.door_slide_open_units;
	if(!isdefined(c_door.m_s_bundle.door_swing_angle))
	{
		c_door.m_s_bundle.door_swing_angle = 0;
	}
	if(isdefined(c_door.m_s_bundle.door_closes) && c_door.m_s_bundle.door_closes)
	{
		n_door_closes = 1;
	}
	else
	{
		n_door_closes = 0;
	}
	if(isdefined(c_door.m_s_bundle.door_connect_paths) && c_door.m_s_bundle.door_connect_paths)
	{
		n_door_connect_paths = 1;
	}
	else
	{
		n_door_connect_paths = 0;
	}
	if(isdefined(c_door.m_s_bundle.door_start_open) && c_door.m_s_bundle.door_start_open)
	{
		c_door flag::set("open");
	}
	if(isdefined(c_door.m_str_script_flag))
	{
		a_flags = strtok(c_door.m_str_script_flag, ",");
		foreach(str_flag in a_flags)
		{
			level flag::init(str_flag);
		}
	}
	[[ c_door ]]->init_xmodel(str_door_xmodel, n_door_connect_paths, s_door_instance.origin, s_door_instance.angles);
	[[ c_door ]]->init_trigger(v_trigger_offset, n_trigger_radius, c_door.m_s_bundle);
	[[ c_door ]]->init_hint_trigger();
	thread [[ c_door ]]->run_lock_fx();
	[[ c_door ]]->init_movement(n_slide_up, n_slide_amount);
	if(!isdefined(c_door.m_s_bundle.door_open_time))
	{
		c_door.m_s_bundle.door_open_time = 0.4;
	}
	[[ c_door ]]->set_door_paths(n_door_connect_paths);
	c_door.m_s_bundle.b_loop_sound = isdefined(c_door.m_s_bundle.door_loop_sound) && c_door.m_s_bundle.door_loop_sound != "";
	level thread door_update(c_door);
	return c_door;
}

/*
	Name: door_open_update
	Namespace: doors
	Checksum: 0x8243F2C9
	Offset: 0x2728
	Size: 0x3C8
	Parameters: 1
	Flags: Linked
*/
function door_open_update(c_door)
{
	str_unlock_method = "default";
	if(isdefined(c_door.m_s_bundle.door_unlock_method))
	{
		str_unlock_method = c_door.m_s_bundle.door_unlock_method;
	}
	b_auto_close = isdefined(c_door.m_s_bundle.door_closes) && c_door.m_s_bundle.door_closes && (!(isdefined(c_door.m_s_bundle.door_use_trigger) && c_door.m_s_bundle.door_use_trigger));
	b_hold_open = isdefined(c_door.m_s_bundle.door_use_hold) && c_door.m_s_bundle.door_use_hold;
	b_manual_close = isdefined(c_door.m_s_bundle.door_use_trigger) && c_door.m_s_bundle.door_use_trigger && (isdefined(c_door.m_s_bundle.door_closes) && c_door.m_s_bundle.door_closes);
	while(true)
	{
		c_door.m_e_trigger waittill(#"trigger", e_who);
		c_door.m_e_trigger_player = e_who;
		if(!c_door flag::get("open"))
		{
			if(!c_door flag::get("locked"))
			{
				if(b_hold_open || b_auto_close)
				{
					[[ c_door ]]->open();
					if(b_hold_open)
					{
						e_who player_freeze_in_place(1);
						e_who disableweapons();
						e_who disableoffhandweapons();
					}
					door_wait_until_clear(c_door, e_who);
					[[ c_door ]]->close();
					if(b_hold_open)
					{
						wait(0.05);
						c_door flag::wait_till_clear("animating");
						e_who player_freeze_in_place(0);
						e_who enableweapons();
						e_who enableoffhandweapons();
					}
				}
				else
				{
					if(str_unlock_method == "key")
					{
						if(e_who player_has_key("door"))
						{
							e_who player_take_key("door");
							[[ c_door ]]->open();
						}
						else
						{
							iprintlnbold("You need a key.");
						}
					}
					else
					{
						[[ c_door ]]->open();
					}
				}
			}
		}
		else if(b_manual_close)
		{
			[[ c_door ]]->close();
		}
	}
}

/*
	Name: door_update
	Namespace: doors
	Checksum: 0xB03FB4DF
	Offset: 0x2AF8
	Size: 0x272
	Parameters: 1
	Flags: Linked
*/
function door_update(c_door)
{
	str_unlock_method = "default";
	if(isdefined(c_door.m_s_bundle.door_unlock_method))
	{
		str_unlock_method = c_door.m_s_bundle.door_unlock_method;
	}
	if(isdefined(c_door.m_s_bundle.door_locked) && c_door.m_s_bundle.door_locked && str_unlock_method != "key")
	{
		c_door flag::set("locked");
		if(isdefined(c_door.m_str_targetname))
		{
			thread door_update_lock_scripted(c_door);
		}
	}
	thread door_open_update(c_door);
	[[ c_door ]]->update_use_message();
	while(true)
	{
		if(c_door flag::get("locked"))
		{
			c_door flag::wait_till_clear("locked");
		}
		c_door flag::wait_till("open");
		if(c_door.m_door_open_delay_time > 0)
		{
			c_door.m_e_door notify(#"door_waiting_to_open", c_door.m_e_trigger_player);
			wait(c_door.m_door_open_delay_time);
		}
		[[ c_door ]]->open_internal();
		c_door flag::wait_till_clear("open");
		[[ c_door ]]->close_internal();
		if(!(isdefined(c_door.m_s_bundle.door_closes) && c_door.m_s_bundle.door_closes))
		{
			break;
		}
		wait(0.05);
	}
	c_door.m_e_trigger delete();
	c_door.m_e_trigger = undefined;
}

/*
	Name: door_update_lock_scripted
	Namespace: doors
	Checksum: 0xD1A569CD
	Offset: 0x2D78
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function door_update_lock_scripted(c_door)
{
	door_str = c_door.m_str_targetname;
	c_door.m_e_trigger.targetname = door_str + "_trig";
	while(true)
	{
		c_door.m_e_trigger waittill(#"unlocked");
		[[ c_door ]]->unlock();
	}
}

/*
	Name: player_freeze_in_place
	Namespace: doors
	Checksum: 0xFE6C3B34
	Offset: 0x2E00
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function player_freeze_in_place(b_do_freeze)
{
	if(!b_do_freeze)
	{
		if(isdefined(self.freeze_origin))
		{
			self unlink();
			self.freeze_origin delete();
			self.freeze_origin = undefined;
		}
	}
	else if(!isdefined(self.freeze_origin))
	{
		self.freeze_origin = spawn("script_model", self.origin);
		self.freeze_origin setmodel("tag_origin");
		self.freeze_origin.angles = self.angles;
		self playerlinktodelta(self.freeze_origin, "tag_origin", 1, 45, 45, 45, 45);
	}
}

/*
	Name: trigger_wait_until_clear
	Namespace: doors
	Checksum: 0xCD587D65
	Offset: 0x2F28
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function trigger_wait_until_clear(c_door)
{
	self endon(#"death");
	last_trigger_time = gettime();
	self.ents_in_trigger = 1;
	str_kill_trigger_notify = "trigger_now_clear";
	self thread trigger_check_for_ents_touching(str_kill_trigger_notify);
	while(true)
	{
		time = gettime();
		if(self.ents_in_trigger == 1)
		{
			self.ents_in_trigger = 0;
			last_trigger_time = time;
		}
		dt = (time - last_trigger_time) / 1000;
		if(dt >= 0.3)
		{
			break;
		}
		wait(0.05);
	}
	self notify(str_kill_trigger_notify);
}

/*
	Name: door_wait_until_user_release
	Namespace: doors
	Checksum: 0x6954BD70
	Offset: 0x3020
	Size: 0xF6
	Parameters: 3
	Flags: Linked
*/
function door_wait_until_user_release(c_door, e_triggerer, str_kill_on_door_notify)
{
	if(isdefined(str_kill_on_door_notify))
	{
		c_door endon(str_kill_on_door_notify);
	}
	wait(0.25);
	max_dist_sq = c_door.m_s_bundle.door_trigger_radius * c_door.m_s_bundle.door_trigger_radius;
	b_pressed = 1;
	n_dist = 0;
	do
	{
		wait(0.05);
		b_pressed = e_triggerer usebuttonpressed();
		n_dist = distancesquared(e_triggerer.origin, self.origin);
	}
	while(b_pressed && n_dist < max_dist_sq);
}

/*
	Name: door_wait_until_clear
	Namespace: doors
	Checksum: 0x4F1D9DC3
	Offset: 0x3120
	Size: 0x214
	Parameters: 2
	Flags: Linked
*/
function door_wait_until_clear(c_door, e_triggerer)
{
	e_trigger = c_door.m_e_trigger;
	e_temp_trigger = undefined;
	if(isdefined(c_door.m_s_bundle.door_trigger_at_target) && c_door.m_s_bundle.door_trigger_at_target)
	{
		e_door = c_door.m_e_door;
		v_trigger_offset = c_door.m_s_bundle.v_trigger_offset;
		v_pos = [[ c_door ]]->calculate_offset_position(e_door.origin, e_door.angles, v_trigger_offset);
		n_radius = c_door.m_s_bundle.door_trigger_radius;
		n_height = c_door.m_n_trigger_height;
		e_temp_trigger = spawn("trigger_radius", v_pos, 0, n_radius, n_height);
		e_trigger = e_temp_trigger;
	}
	if(isplayer(e_triggerer) && (isdefined(c_door.m_s_bundle.door_use_hold) && c_door.m_s_bundle.door_use_hold))
	{
		c_door.m_e_trigger door_wait_until_user_release(c_door, e_triggerer);
	}
	e_trigger trigger_wait_until_clear(c_door);
	if(isdefined(e_temp_trigger))
	{
		e_temp_trigger delete();
	}
}

/*
	Name: trigger_check_for_ents_touching
	Namespace: doors
	Checksum: 0xEE1AFFA2
	Offset: 0x3340
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function trigger_check_for_ents_touching(str_kill_trigger_notify)
{
	self endon(#"death");
	self endon(str_kill_trigger_notify);
	while(true)
	{
		self waittill(#"trigger", e_who);
		self.ents_in_trigger = 1;
	}
}

/*
	Name: door_debug_line
	Namespace: doors
	Checksum: 0x517BA6BF
	Offset: 0x3398
	Size: 0x90
	Parameters: 1
	Flags: None
*/
function door_debug_line(v_origin)
{
	self endon(#"death");
	while(true)
	{
		v_start = v_origin;
		v_end = v_start + vectorscale((0, 0, 1), 1000);
		v_col = (0, 0, 1);
		/#
			line(v_start, v_end, (0, 0, 1));
		#/
		wait(0.1);
	}
}

/*
	Name: player_has_key
	Namespace: doors
	Checksum: 0xA3E29DB3
	Offset: 0x3430
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function player_has_key(str_key_type)
{
	if(!isdefined(self.collectible_keys))
	{
		return 0;
	}
	if(!isdefined(self.collectible_keys[str_key_type]))
	{
		return 0;
	}
	return self.collectible_keys[str_key_type].num_keys > 0;
}

/*
	Name: player_take_key
	Namespace: doors
	Checksum: 0xFF21EF6D
	Offset: 0x3488
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function player_take_key(str_key_type)
{
	if(!player_has_key(str_key_type))
	{
		return;
	}
	self.collectible_keys[str_key_type].num_keys--;
	if(self.collectible_keys[str_key_type].num_keys <= 0 && isdefined(self.collectible_keys[str_key_type].hudelem))
	{
		self.collectible_keys[str_key_type].hudelem destroy();
		self.collectible_keys[str_key_type].hudelem = undefined;
	}
}

/*
	Name: rotate_key_forever
	Namespace: doors
	Checksum: 0xE8F7B543
	Offset: 0x3550
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function rotate_key_forever()
{
	self endon(#"death");
	while(true)
	{
		self rotateyaw(180, 3);
		wait(2.5);
	}
}

/*
	Name: key_process_timeout
	Namespace: doors
	Checksum: 0x4A64825A
	Offset: 0x3598
	Size: 0x174
	Parameters: 3
	Flags: Linked
*/
function key_process_timeout(n_timeout_sec, e_trigger, e_model)
{
	e_trigger endon(#"death");
	if(n_timeout_sec < 5)
	{
		n_timeout_sec = 5 + 1;
	}
	wait(n_timeout_sec - 5);
	n_stepsize = 0.5;
	b_on = 1;
	f = 0;
	while(f < 5)
	{
		if(b_on)
		{
			e_model hide();
		}
		else
		{
			e_model show();
		}
		b_on = !b_on;
		wait(n_stepsize);
		if(n_stepsize > 0.15)
		{
			n_stepsize = n_stepsize * 0.9;
		}
		f = f + n_stepsize;
	}
	level notify(#"key_drop_timeout");
	e_model delete();
	e_trigger delete();
}

/*
	Name: give_ai_key_internal
	Namespace: doors
	Checksum: 0x40E6EA88
	Offset: 0x3718
	Size: 0x29C
	Parameters: 2
	Flags: Linked
*/
function give_ai_key_internal(n_timeout_sec, str_key_type)
{
	v_pos = self.origin;
	e_model = spawn("script_model", v_pos + vectorscale((0, 0, 1), 80));
	e_model.angles = vectorscale((1, 0, 1), 10);
	e_model setmodel(level.door_key_model);
	if(isdefined(level.door_key_fx))
	{
		playfxontag(level.door_key_fx, e_model, "tag_origin");
	}
	while(isalive(self))
	{
		e_model moveto(self.origin + vectorscale((0, 0, 1), 80), 0.2);
		e_model rotateyaw(30, 0.2);
		wait(0.1);
	}
	e_model movez(-60, 1);
	wait(1);
	e_model thread rotate_key_forever();
	e_trigger = spawn("trigger_radius", e_model.origin, 0, 25, 100);
	if(isdefined(n_timeout_sec))
	{
		level thread key_process_timeout(n_timeout_sec, e_trigger, e_model);
	}
	e_trigger endon(#"death");
	while(true)
	{
		e_trigger waittill(#"trigger", e_who);
		if(isplayer(e_who))
		{
			e_who give_player_key(str_key_type);
			break;
		}
	}
	e_model delete();
	e_trigger delete();
}

/*
	Name: give_ai_key
	Namespace: doors
	Checksum: 0xF57CC901
	Offset: 0x39C0
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function give_ai_key(n_timeout_sec = undefined, str_key_type = "door")
{
	/#
		assert(isdefined(level.door_key_model), "");
	#/
	self thread give_ai_key_internal(n_timeout_sec, str_key_type);
}

/*
	Name: give_player_key
	Namespace: doors
	Checksum: 0x230F1AD7
	Offset: 0x3A50
	Size: 0x210
	Parameters: 1
	Flags: Linked
*/
function give_player_key(str_key_type = "door")
{
	/#
		assert(isdefined(level.door_key_icon), "");
	#/
	if(!isdefined(self.collectible_keys))
	{
		self.collectible_keys = [];
	}
	if(!isdefined(self.collectible_keys[str_key_type]))
	{
		self.collectible_keys[str_key_type] = spawnstruct();
		self.collectible_keys[str_key_type].num_keys = 0;
		self.collectible_keys[str_key_type].type = str_key_type;
	}
	hudelem = self.collectible_keys[str_key_type].hudelem;
	if(!isdefined(hudelem))
	{
		hudelem = newclienthudelem(self);
	}
	hudelem.alignx = "right";
	hudelem.aligny = "bottom";
	hudelem.horzalign = "right";
	hudelem.vertalign = "bottom";
	hudelem.hidewheninmenu = 1;
	hudelem.hidewhenindemo = 1;
	hudelem.y = -75;
	hudelem.x = -25;
	hudelem setshader(level.door_key_icon, 16, 16);
	self.collectible_keys[str_key_type].hudelem = hudelem;
	self.collectible_keys[str_key_type].num_keys++;
}

/*
	Name: unlock_all
	Namespace: doors
	Checksum: 0xBBF92A43
	Offset: 0x3C68
	Size: 0x10E
	Parameters: 1
	Flags: None
*/
function unlock_all(b_do_open = 1)
{
	a_s_inst_list = struct::get_array("scriptbundle_doors", "classname");
	foreach(s_inst in a_s_inst_list)
	{
		c_door = s_inst.c_door;
		if(isdefined(c_door))
		{
			[[ c_door ]]->unlock();
			if(b_do_open)
			{
				[[ c_door ]]->open();
			}
		}
	}
}

/*
	Name: unlock
	Namespace: doors
	Checksum: 0x5DAE71B2
	Offset: 0x3D80
	Size: 0x12A
	Parameters: 3
	Flags: None
*/
function unlock(str_name, str_name_type = "targetname", b_do_open = 1)
{
	a_s_inst_list = struct::get_array(str_name, str_name_type);
	foreach(s_inst in a_s_inst_list)
	{
		if(isdefined(s_inst.c_door))
		{
			[[ s_inst.c_door ]]->unlock();
			if(b_do_open)
			{
				[[ s_inst.c_door ]]->open();
			}
		}
	}
}

