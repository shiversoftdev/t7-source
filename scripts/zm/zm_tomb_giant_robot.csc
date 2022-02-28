// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_tomb_amb;

#namespace zm_tomb_giant_robot;

/*
	Name: init
	Namespace: zm_tomb_giant_robot
	Checksum: 0xE6E67F5A
	Offset: 0x688
	Size: 0x55C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "register_giant_robot", 21000, 1, "int", &register_giant_robot, 0, 0);
	clientfield::register("world", "start_anim_robot_0", 21000, 1, "int", &function_7e19465b, 0, 0);
	clientfield::register("world", "start_anim_robot_1", 21000, 1, "int", &function_7e19465b, 0, 0);
	clientfield::register("world", "start_anim_robot_2", 21000, 1, "int", &function_7e19465b, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_0", 21000, 2, "int", &function_36b7480d, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_1", 21000, 2, "int", &function_36b7480d, 0, 0);
	clientfield::register("world", "play_foot_stomp_fx_robot_2", 21000, 2, "int", &function_36b7480d, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_0", 21000, 2, "int", &function_6e99bd62, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_1", 21000, 2, "int", &function_6e99bd62, 0, 0);
	clientfield::register("world", "play_foot_open_fx_robot_2", 21000, 2, "int", &function_6e99bd62, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_0", 21000, 1, "int", &function_aa136ff9, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_1", 21000, 1, "int", &function_aa136ff9, 0, 0);
	clientfield::register("world", "eject_warning_fx_robot_2", 21000, 1, "int", &function_aa136ff9, 0, 0);
	clientfield::register("scriptmover", "light_foot_fx_robot", 21000, 2, "int", &function_98a05ad2, 0, 0);
	clientfield::register("allplayers", "eject_steam_fx", 21000, 1, "int", &function_d4c69cd, 0, 0);
	clientfield::register("allplayers", "all_tubes_play_eject_steam_fx", 21000, 1, "int", &all_tubes_play_eject_steam_fx, 0, 0);
	clientfield::register("allplayers", "gr_eject_player_impact_fx", 21000, 1, "int", &gr_eject_player_impact_fx, 0, 0);
	clientfield::register("toplayer", "giant_robot_rumble_and_shake", 21000, 2, "int", &giant_robot_rumble_and_shake, 0, 0);
	clientfield::register("world", "church_ceiling_fxanim", 21000, 1, "int", &church_ceiling_fxanim, 0, 0);
}

/*
	Name: register_giant_robot
	Namespace: zm_tomb_giant_robot
	Checksum: 0xA40440CC
	Offset: 0xBF0
	Size: 0xF0
	Parameters: 7
	Flags: Linked
*/
function register_giant_robot(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isdefined(level.a_giant_robots))
	{
		level.a_giant_robots = [];
		level.a_giant_robots[localclientnum] = [];
	}
	if(self.model == "veh_t7_zhd_robot_0")
	{
		level.a_giant_robots[localclientnum][0] = self;
	}
	else
	{
		if(self.model == "veh_t7_zhd_robot_1")
		{
			level.a_giant_robots[localclientnum][1] = self;
		}
		else if(self.model == "veh_t7_zhd_robot_2")
		{
			level.a_giant_robots[localclientnum][2] = self;
		}
	}
}

/*
	Name: function_36b7480d
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8BA9D4D7
	Offset: 0xCE8
	Size: 0x1F4
	Parameters: 7
	Flags: Linked
*/
function function_36b7480d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	ai_robot = function_9f95c19e(localclientnum, fieldname);
	if(!isdefined(ai_robot))
	{
		return;
	}
	ai_robot thread function_d46dfa88(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump);
	if(newval == 1)
	{
		ai_robot.var_16a8765e = playfxontag(localclientnum, level._effect["robot_foot_stomp"], ai_robot, "tag_hatch_fx_ri");
		origin = ai_robot gettagorigin("tag_hatch_fx_ri");
		playsound(0, "zmb_robot_foot_impact", origin);
	}
	else if(newval == 2)
	{
		ai_robot.var_16a8765e = playfxontag(localclientnum, level._effect["robot_foot_stomp"], ai_robot, "tag_hatch_fx_le");
		origin = ai_robot gettagorigin("tag_hatch_fx_le");
		playsound(0, "zmb_robot_foot_impact", origin);
	}
	setfxignorepause(localclientnum, ai_robot.var_16a8765e, 1);
}

/*
	Name: function_98a05ad2
	Namespace: zm_tomb_giant_robot
	Checksum: 0x283316E3
	Offset: 0xEE8
	Size: 0x13C
	Parameters: 7
	Flags: Linked
*/
function function_98a05ad2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self.var_e655463b = playfxontag(localclientnum, level._effect["giant_robot_foot_light"], self, "tag_foot_bottom_left");
		setfxignorepause(localclientnum, self.var_e655463b, 1);
	}
	else
	{
		if(newval == 2)
		{
			self.var_e655463b = playfxontag(localclientnum, level._effect["giant_robot_foot_light"], self, "tag_foot_bottom_right");
			setfxignorepause(localclientnum, self.var_e655463b, 1);
		}
		else if(isdefined(self.var_e655463b))
		{
			killfx(localclientnum, self.var_e655463b);
		}
	}
}

/*
	Name: function_6e99bd62
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3B274852
	Offset: 0x1030
	Size: 0x394
	Parameters: 7
	Flags: Linked
*/
function function_6e99bd62(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	ai_robot = function_9f95c19e(localclientnum, fieldname);
	if(!isdefined(ai_robot))
	{
		return;
	}
	v_fx_offset = vectorscale((0, 0, 1), 56);
	if(newval == 1)
	{
		v_fx_pos = ai_robot gettagorigin("tag_hatch_fx_ri");
		v_fx_pos = v_fx_pos - v_fx_offset;
		ai_robot.var_140b6e83 = spawn(localclientnum, v_fx_pos, "script_model");
		ai_robot.var_140b6e83 setmodel("tag_origin");
		ai_robot.var_140b6e83 linkto(ai_robot, "tag_hatch_fx_ri");
		ai_robot.var_140b6e83 playsound(0, "zmb_zombieblood_3rd_plane_explode");
		ai_robot.var_140b6e83.n_death_fx = playfxontag(localclientnum, level._effect["mechz_death"], ai_robot.var_140b6e83, "tag_origin");
		setfxignorepause(localclientnum, ai_robot.var_140b6e83.n_death_fx, 1);
	}
	else
	{
		if(newval == 2)
		{
			v_fx_pos = ai_robot gettagorigin("tag_hatch_fx_le");
			v_fx_pos = v_fx_pos - v_fx_offset;
			ai_robot.var_140b6e83 = spawn(localclientnum, v_fx_pos, "script_model");
			ai_robot.var_140b6e83 setmodel("tag_origin");
			ai_robot.var_140b6e83 linkto(ai_robot, "tag_hatch_fx_le");
			ai_robot.var_140b6e83 playsound(0, "zmb_zombieblood_3rd_plane_explode");
			ai_robot.var_140b6e83.n_death_fx = playfxontag(localclientnum, level._effect["mechz_death"], ai_robot.var_140b6e83, "tag_origin");
			setfxignorepause(localclientnum, ai_robot.var_140b6e83.n_death_fx, 1);
		}
		else if(isdefined(ai_robot.var_140b6e83))
		{
			ai_robot.var_140b6e83 delete();
		}
	}
}

/*
	Name: function_aa136ff9
	Namespace: zm_tomb_giant_robot
	Checksum: 0xBE012B68
	Offset: 0x13D0
	Size: 0x1A4
	Parameters: 7
	Flags: Linked
*/
function function_aa136ff9(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		s_origin = struct::get(fieldname, "targetname");
		v_fx_pos = s_origin.origin;
		level.fieldname[localclientnum] = spawn(localclientnum, v_fx_pos, "script_model");
		level.fieldname[localclientnum] setmodel("tag_origin");
		level.fieldname[localclientnum].var_68f810db = playfxontag(localclientnum, level._effect["eject_warning"], level.fieldname[localclientnum], "tag_origin");
		setfxignorepause(localclientnum, level.fieldname[localclientnum].var_68f810db, 1);
	}
	else if(isdefined(level.fieldname[localclientnum]))
	{
		level.fieldname[localclientnum] delete();
	}
}

/*
	Name: function_d4c69cd
	Namespace: zm_tomb_giant_robot
	Checksum: 0x5A64DD06
	Offset: 0x1580
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_d4c69cd(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self thread function_691b8375(localclientnum);
	}
	else
	{
		self notify(#"stop_eject_steam_fx");
		if(isdefined(self.fieldname))
		{
			stopfx(localclientnum, self.fieldname);
		}
	}
}

/*
	Name: function_691b8375
	Namespace: zm_tomb_giant_robot
	Checksum: 0x43D184B6
	Offset: 0x1630
	Size: 0x150
	Parameters: 1
	Flags: Linked
*/
function function_691b8375(localclientnum)
{
	self endon(#"stop_eject_steam_fx");
	self endon(#"player_intermission");
	var_bd5df270 = struct::get_array("giant_robot_eject_tube", "script_noteworthy");
	s_tube = arraygetclosest(self.origin, var_bd5df270);
	self thread function_caeb1b02("stop_eject_steam_fx", s_tube.origin);
	while(isdefined(self))
	{
		self.fieldname = playfx(localclientnum, level._effect["eject_steam"], s_tube.origin, anglestoforward(s_tube.angles), anglestoup(s_tube.angles));
		setfxignorepause(localclientnum, self.fieldname, 1);
		wait(0.1);
	}
}

/*
	Name: all_tubes_play_eject_steam_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x58EB7369
	Offset: 0x1788
	Size: 0x23E
	Parameters: 7
	Flags: Linked
*/
function all_tubes_play_eject_steam_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		var_66a1e889 = struct::get_array("giant_robot_eject_tube", "script_noteworthy");
		var_8356f695 = arraygetclosest(self.origin, var_66a1e889);
		n_robot_id = var_8356f695.script_int;
		level.var_bd5df270 = [];
		level.var_bd5df270[localclientnum] = [];
		n_index = 0;
		foreach(struct in var_66a1e889)
		{
			if(struct.script_int == n_robot_id)
			{
				struct thread function_3ae72e85(localclientnum);
				level.var_bd5df270[localclientnum][n_index] = struct;
				n_index++;
			}
		}
	}
	else if(isdefined(level.var_bd5df270[localclientnum]))
	{
		foreach(struct in level.var_bd5df270[localclientnum])
		{
			struct notify(#"stop_all_tubes_eject_steam");
		}
	}
}

/*
	Name: function_3ae72e85
	Namespace: zm_tomb_giant_robot
	Checksum: 0xD3492BFD
	Offset: 0x19D0
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function function_3ae72e85(localclientnum)
{
	self endon(#"stop_all_tubes_eject_steam");
	self thread function_caeb1b02("stop_all_tubes_eject_steam", self.origin);
	while(true)
	{
		self.var_d1c8c63f = playfx(localclientnum, level._effect["eject_steam"], self.origin, anglestoforward(self.angles), anglestoup(self.angles));
		setfxignorepause(localclientnum, self.var_d1c8c63f, 1);
		wait(0.1);
	}
}

/*
	Name: function_caeb1b02
	Namespace: zm_tomb_giant_robot
	Checksum: 0x21E2AB7A
	Offset: 0x1AB0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function function_caeb1b02(var_365d1fde, origin)
{
	audio::playloopat("zmb_bot_timeout_steam", origin);
	self waittill(var_365d1fde);
	audio::stoploopat("zmb_bot_timeout_steam", origin);
}

/*
	Name: gr_eject_player_impact_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x158A1F04
	Offset: 0x1B18
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function gr_eject_player_impact_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self.fieldname = playfx(localclientnum, level._effect["beacon_shell_explosion"], self.origin);
		setfxignorepause(localclientnum, self.fieldname, 1);
	}
	else if(isdefined(self.fieldname))
	{
		stopfx(localclientnum, self.fieldname);
	}
}

/*
	Name: function_9f95c19e
	Namespace: zm_tomb_giant_robot
	Checksum: 0x2B020F8B
	Offset: 0x1BF8
	Size: 0x128
	Parameters: 2
	Flags: Linked
*/
function function_9f95c19e(localclientnum, fieldname)
{
	if(!isdefined(level.a_giant_robots) || !isdefined(level.a_giant_robots[localclientnum]))
	{
		return undefined;
	}
	ai_robot = undefined;
	if(issubstr(fieldname, 0))
	{
		ai_robot = level.a_giant_robots[localclientnum][0];
		if(isdefined(ai_robot))
		{
			ai_robot.var_90d8d560 = 0;
		}
	}
	else
	{
		if(issubstr(fieldname, 1))
		{
			ai_robot = level.a_giant_robots[localclientnum][1];
			if(isdefined(ai_robot))
			{
				ai_robot.var_90d8d560 = 1;
			}
		}
		else
		{
			ai_robot = level.a_giant_robots[localclientnum][2];
			if(isdefined(ai_robot))
			{
				ai_robot.var_90d8d560 = 2;
			}
		}
	}
	return ai_robot;
}

/*
	Name: function_7e19465b
	Namespace: zm_tomb_giant_robot
	Checksum: 0x1AD288B8
	Offset: 0x1D28
	Size: 0x436
	Parameters: 7
	Flags: Linked
*/
function function_7e19465b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isdefined(level.var_58b72d2f))
	{
		level.var_58b72d2f = [];
		level.var_58b72d2f[0] = spawnstruct();
		level.var_58b72d2f[0].struct_name = "nml_warn_light_fp_ref";
		level.var_58b72d2f[0].var_11927f3d = struct::get_array("nml_foot_warn_light", "targetname");
		/#
			assert(level.var_58b72d2f[0].var_11927f3d.size > 0, "");
		#/
		level.var_58b72d2f[1] = spawnstruct();
		level.var_58b72d2f[1].struct_name = "trench_warn_light_fp_ref";
		level.var_58b72d2f[1].var_11927f3d = [];
		level.var_58b72d2f[1].var_11927f3d = struct::get_array("trench_foot_warn_light", "targetname");
		/#
			assert(level.var_58b72d2f[1].var_11927f3d.size > 0, "");
		#/
		level.var_58b72d2f[2] = spawnstruct();
		level.var_58b72d2f[2].struct_name = "church_warn_light_fp_ref";
		level.var_58b72d2f[2].var_11927f3d = [];
		level.var_58b72d2f[2].var_11927f3d = struct::get_array("church_foot_warn_light", "targetname");
		/#
			assert(level.var_58b72d2f[2].var_11927f3d.size > 0, "");
		#/
	}
	ai_robot = function_9f95c19e(localclientnum, fieldname);
	if(!isdefined(ai_robot) || !isdefined(level.var_58b72d2f[ai_robot.var_90d8d560]))
	{
		return;
	}
	if(newval == 1)
	{
		ai_robot.var_6e5e4d07 = struct::get(level.var_58b72d2f[ai_robot.var_90d8d560].struct_name + "_left", "targetname");
		ai_robot.var_bd0d6d82 = struct::get(level.var_58b72d2f[ai_robot.var_90d8d560].struct_name + "_right", "targetname");
		ai_robot function_bbae1203(localclientnum, ai_robot.var_6e5e4d07);
		ai_robot function_bbae1203(localclientnum, ai_robot.var_bd0d6d82);
	}
	else
	{
		ai_robot function_aacf48b5(localclientnum);
		ai_robot.var_6e5e4d07 = undefined;
		ai_robot.var_bd0d6d82 = undefined;
	}
}

/*
	Name: function_bbae1203
	Namespace: zm_tomb_giant_robot
	Checksum: 0xFCB0A1A7
	Offset: 0x2168
	Size: 0x182
	Parameters: 2
	Flags: Linked
*/
function function_bbae1203(localclientnum, var_75158c9e)
{
	a_lights = function_d31a2386(var_75158c9e);
	foreach(light in a_lights)
	{
		if(!isdefined(light.var_1398bc94))
		{
			if(!isdefined(light.angles))
			{
				light.angles = (0, 0, 0);
			}
			light.var_1398bc94 = playfx(localclientnum, level._effect["giant_robot_footstep_warning_light"], light.origin, anglestoforward(light.angles), anglestoup(light.angles));
			setfxignorepause(localclientnum, light.var_1398bc94, 1);
		}
	}
}

/*
	Name: function_d91e5529
	Namespace: zm_tomb_giant_robot
	Checksum: 0x131D5F0F
	Offset: 0x22F8
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function function_d91e5529(localclientnum, var_75158c9e)
{
	a_lights = function_d31a2386(var_75158c9e);
	foreach(light in a_lights)
	{
		if(isdefined(light.var_1398bc94))
		{
			stopfx(localclientnum, light.var_1398bc94);
			light.var_1398bc94 = undefined;
		}
	}
}

/*
	Name: function_aacf48b5
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8C670ED3
	Offset: 0x23E8
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function function_aacf48b5(localclientnum)
{
	foreach(light in level.var_58b72d2f[self.var_90d8d560].var_11927f3d)
	{
		if(isdefined(light.var_1398bc94))
		{
			stopfx(localclientnum, light.var_1398bc94);
			light.var_1398bc94 = undefined;
		}
	}
}

/*
	Name: function_d31a2386
	Namespace: zm_tomb_giant_robot
	Checksum: 0x6998DA17
	Offset: 0x24C0
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function function_d31a2386(var_75158c9e)
{
	var_fa1ca319 = [];
	foreach(light in level.var_58b72d2f[self.var_90d8d560].var_11927f3d)
	{
		if(distancesquared(var_75158c9e.origin, light.origin) < 640000)
		{
			if(!isdefined(var_fa1ca319))
			{
				var_fa1ca319 = [];
			}
			else if(!isarray(var_fa1ca319))
			{
				var_fa1ca319 = array(var_fa1ca319);
			}
			var_fa1ca319[var_fa1ca319.size] = light;
		}
	}
	return var_fa1ca319;
}

/*
	Name: function_d46dfa88
	Namespace: zm_tomb_giant_robot
	Checksum: 0xD7CD3697
	Offset: 0x2600
	Size: 0x262
	Parameters: 7
	Flags: Linked
*/
function function_d46dfa88(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	wait(1);
	if(newval == 1)
	{
		if(isdefined(self.var_bd0d6d82))
		{
			var_8f93a98e = self gettagorigin("tag_hatch_fx_ri");
			if(distancesquared(self.var_bd0d6d82.origin, var_8f93a98e) < (300 * 300))
			{
				function_d91e5529(localclientnum, self.var_bd0d6d82);
				wait(0.05);
				if(isdefined(self.var_bd0d6d82.target))
				{
					self.var_bd0d6d82 = struct::get(self.var_bd0d6d82.target, "targetname");
					function_bbae1203(localclientnum, self.var_bd0d6d82);
				}
				else
				{
					self.var_bd0d6d82 = undefined;
				}
			}
		}
	}
	else if(newval == 2)
	{
		if(isdefined(self.var_6e5e4d07))
		{
			var_8f93a98e = self gettagorigin("tag_hatch_fx_le");
			if(distancesquared(self.var_6e5e4d07.origin, var_8f93a98e) < (300 * 300))
			{
				function_d91e5529(localclientnum, self.var_6e5e4d07);
				wait(0.05);
				if(isdefined(self.var_6e5e4d07.target))
				{
					self.var_6e5e4d07 = struct::get(self.var_6e5e4d07.target, "targetname");
					function_bbae1203(localclientnum, self.var_6e5e4d07);
				}
				else
				{
					self.var_6e5e4d07 = undefined;
				}
			}
		}
	}
}

/*
	Name: giant_robot_rumble_and_shake
	Namespace: zm_tomb_giant_robot
	Checksum: 0x72816DDB
	Offset: 0x2870
	Size: 0x1D6
	Parameters: 7
	Flags: Linked
*/
function giant_robot_rumble_and_shake(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"disconnect");
	if(newval == 3)
	{
		self earthquake(0.6, 1.5, self.origin, 100);
		self playrumbleonentity(localclientnum, "artillery_rumble");
		soundrattle(self.origin, 250, 750);
	}
	else
	{
		if(newval == 2)
		{
			self earthquake(0.3, 1.5, self.origin, 100);
			self playrumbleonentity(localclientnum, "shotgun_fire");
			soundrattle(self.origin, 100, 500);
		}
		else
		{
			if(newval == 1)
			{
				self earthquake(0.1, 1, self.origin, 100);
				self playrumbleonentity(localclientnum, "damage_heavy");
				soundrattle(self.origin, 10, 350);
			}
			else
			{
				self notify(#"hash_ee5c27b3");
			}
		}
	}
}

/*
	Name: church_ceiling_fxanim
	Namespace: zm_tomb_giant_robot
	Checksum: 0x95EB4014
	Offset: 0x2A50
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function church_ceiling_fxanim(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		var_61cbe98c = getent(localclientnum, "church_ceiling", "targetname");
		var_61cbe98c scene::play("p7_fxanim_zm_ori_church_ceiling_bundle", var_61cbe98c);
	}
}

