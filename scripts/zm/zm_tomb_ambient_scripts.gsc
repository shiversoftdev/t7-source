// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_tomb_ambient_scripts;

/*
	Name: init_tomb_ambient_scripts
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0xB9151EC8
	Offset: 0x348
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function init_tomb_ambient_scripts()
{
	clientfield::register("scriptmover", "zeppelin_fx", 21000, 1, "int");
}

/*
	Name: main
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0x84934736
	Offset: 0x388
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread init_zeppelin("sky_cowbell_zeppelin_low", "stop_ambient_zeppelins");
	util::delay(20, undefined, &init_zeppelin, "sky_cowbell_zeppelin_mid", "stop_ambient_zeppelins");
	util::delay(40, undefined, &init_zeppelin, "sky_cowbell_zeppelin_high", "stop_ambient_zeppelins");
}

/*
	Name: init_zeppelin
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0x40CE1A5F
	Offset: 0x430
	Size: 0xD8
	Parameters: 2
	Flags: Linked
*/
function init_zeppelin(str_script_noteworthy, str_ender)
{
	level endon(str_ender);
	a_path_structs = struct::get_array(str_script_noteworthy, "script_noteworthy");
	if(a_path_structs.size > 0)
	{
		m_zeppelin = util::spawn_model("veh_t7_dlc_zm_zeppelin", (0, 0, 0));
		m_zeppelin setforcenocull();
		m_zeppelin clientfield::set("zeppelin_fx", 1);
		while(true)
		{
			m_zeppelin move_zeppelin_down_new_path(a_path_structs);
		}
	}
}

/*
	Name: move_zeppelin_down_new_path
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0x8DB9A111
	Offset: 0x510
	Size: 0x1E0
	Parameters: 1
	Flags: Linked
*/
function move_zeppelin_down_new_path(a_structs)
{
	s_path_start = get_unused_struct(a_structs);
	self ghost();
	self moveto(s_path_start.origin, 0.1);
	self rotateto(s_path_start.angles, 0.1);
	self waittill(#"movedone");
	self show();
	if(!isdefined(s_path_start.goal_struct))
	{
		/#
			assert(isdefined(s_path_start.target), ("" + s_path_start.origin) + "");
		#/
		s_path_start.goal_struct = struct::get(s_path_start.target, "targetname");
		/#
			assert(isdefined(s_path_start.goal_struct), "" + s_path_start.origin);
		#/
	}
	n_move_time = randomfloatrange(120, 150);
	self moveto(s_path_start.goal_struct.origin, n_move_time);
	self waittill(#"movedone");
}

/*
	Name: get_unused_struct
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0x370DBA90
	Offset: 0x6F8
	Size: 0x190
	Parameters: 1
	Flags: Linked
*/
function get_unused_struct(a_structs)
{
	a_valid_structs = [];
	b_no_unused_structs = 0;
	while(!a_valid_structs.size)
	{
		foreach(struct in a_structs)
		{
			if(!isdefined(struct.used) || b_no_unused_structs)
			{
				struct.used = 0;
			}
			if(!struct.used)
			{
				if(!isdefined(a_valid_structs))
				{
					a_valid_structs = [];
				}
				else if(!isarray(a_valid_structs))
				{
					a_valid_structs = array(a_valid_structs);
				}
				a_valid_structs[a_valid_structs.size] = struct;
			}
		}
		if(!a_valid_structs.size)
		{
			b_no_unused_structs = 1;
		}
	}
	s_unused = array::random(a_valid_structs);
	s_unused.used = 1;
	return s_unused;
}

/*
	Name: function_add29756
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0x20A75E48
	Offset: 0x890
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_add29756()
{
	var_e1149395 = getent("ambiance_dogfights_1", "targetname");
	var_7170dfe = getent("ambiance_dogfights_2", "targetname");
	if(!level.optimise_for_splitscreen)
	{
		level flag::init("animation_plane_1_done");
		level flag::init("animation_plane_2_done");
		level flag::init("play_animation_planes");
		var_e1149395.var_76d4be72 = "animation_plane_1_done";
		var_7170dfe.var_76d4be72 = "animation_plane_2_done";
		level.var_1766c187 = 0;
		var_e1149395 thread function_b6165329();
		var_7170dfe thread function_b6165329();
		level thread function_511ab91d();
	}
	else
	{
		var_e1149395 delete();
		var_7170dfe delete();
	}
}

/*
	Name: function_b6165329
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0x8CBBD44E
	Offset: 0xA08
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_b6165329()
{
	while(true)
	{
		level flag::wait_till("play_animation_planes");
		self scene::play(self.str_scene, self);
		level flag::set(self.var_76d4be72);
	}
}

/*
	Name: function_511ab91d
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0xBF47243D
	Offset: 0xA80
	Size: 0x230
	Parameters: 0
	Flags: Linked
*/
function function_511ab91d()
{
	var_e1149395 = getent("ambiance_dogfights_1", "targetname");
	var_7170dfe = getent("ambiance_dogfights_2", "targetname");
	while(true)
	{
		var_f4570d42 = randomint(3);
		if(level.var_1766c187)
		{
			var_f4570d42 = 0;
		}
		switch(var_f4570d42)
		{
			case 0:
			{
				var_e1149395.str_scene = "p7_fxanim_zm_ori_dogfights_bundle";
				var_7170dfe.str_scene = "p7_fxanim_zm_ori_dogfights_bundle";
				level.var_1766c187 = 0;
				break;
			}
			case 1:
			{
				var_e1149395.str_scene = "p7_fxanim_zm_ori_dogfights_smoke_bundle";
				var_7170dfe.str_scene = "p7_fxanim_zm_ori_dogfights_bundle";
				level.var_1766c187 = 1;
				break;
			}
			case 2:
			{
				var_e1149395.str_scene = "p7_fxanim_zm_ori_dogfights_bundle";
				var_7170dfe.str_scene = "p7_fxanim_zm_ori_dogfights_smoke_bundle";
				level.var_1766c187 = 1;
				break;
			}
		}
		level flag::set("play_animation_planes");
		level flag::wait_till("animation_plane_1_done");
		level flag::wait_till("animation_plane_2_done");
		level flag::clear("animation_plane_1_done");
		level flag::clear("animation_plane_2_done");
		level flag::clear("play_animation_planes");
	}
}

