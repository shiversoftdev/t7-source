// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace mapping_drone;

/*
	Name: spawn_drone
	Namespace: mapping_drone
	Checksum: 0xFEA59928
	Offset: 0x248
	Size: 0x180
	Parameters: 2
	Flags: Linked
*/
function spawn_drone(str_start_node, b_active = 1)
{
	level.vh_mapper = vehicle::simple_spawn_single("mapping_drone");
	level.vh_mapper.animname = "mapping_drone";
	level.vh_mapper setcandamage(0);
	level.vh_mapper notsolid();
	level.vh_mapper sethoverparams(20, 5, 10);
	level.vh_mapper.drivepath = 1;
	if(!b_active)
	{
		level.vh_mapper vehicle::lights_off();
		level.vh_mapper vehicle::toggle_sounds(0);
	}
	if(isdefined(str_start_node))
	{
		nd_start = getvehiclenode(str_start_node, "targetname");
		level.vh_mapper.origin = nd_start.origin;
		level.vh_mapper.angles = nd_start.angles;
	}
}

/*
	Name: follow_path
	Namespace: mapping_drone
	Checksum: 0x218D5D8C
	Offset: 0x3D0
	Size: 0x104
	Parameters: 3
	Flags: Linked
*/
function follow_path(str_start_node, str_flag, var_178571be)
{
	if(isdefined(str_flag) && !level flag::get(str_flag))
	{
		nd_start = getvehiclenode(str_start_node, "targetname");
		self setvehgoalpos(nd_start.origin, 1);
		level flag::wait_till(str_flag);
		self clearvehgoalpos();
	}
	if(isdefined(var_178571be))
	{
		self thread [[var_178571be]]();
	}
	self thread function_fb6d201d();
	self vehicle::get_on_and_go_path(str_start_node);
}

/*
	Name: function_6a8adcf6
	Namespace: mapping_drone
	Checksum: 0x9C0E144F
	Offset: 0x4E0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_6a8adcf6(n_speed)
{
	self.n_speed_override = n_speed;
	self setspeed(self.n_speed_override, 35, 35);
}

/*
	Name: function_2dde6e87
	Namespace: mapping_drone
	Checksum: 0x162D9E4C
	Offset: 0x528
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function function_2dde6e87()
{
	self.n_speed_override = undefined;
}

/*
	Name: function_74191a2
	Namespace: mapping_drone
	Checksum: 0xEAD26998
	Offset: 0x540
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_74191a2(var_e3262ea5 = 1)
{
	if(var_e3262ea5)
	{
		self vehicle::lights_off();
	}
	else
	{
		self vehicle::lights_on();
	}
}

/*
	Name: function_fb6d201d
	Namespace: mapping_drone
	Checksum: 0x6A7A756C
	Offset: 0x5A0
	Size: 0x468
	Parameters: 0
	Flags: Linked
*/
function function_fb6d201d()
{
	self endon(#"stop_speed_regulator");
	self endon(#"reached_end_node");
	n_forward_view = cos(89);
	/#
		self thread function_3c36d48d();
	#/
	self.n_speed = 0;
	while(true)
	{
		if(isdefined(self.n_speed_override))
		{
			self.n_speed = self.n_speed_override;
			self setspeed(self.n_speed_override, 35, 35);
			wait(0.05);
			continue;
		}
		n_lowest_height_offset = 10000;
		n_closest_dist_sq = 9000000;
		b_player_is_ahead = 0;
		var_a8dc514 = 0;
		b_wait_for_player = 0;
		foreach(player in level.players)
		{
			if(!isalive(player))
			{
				continue;
			}
			n_height_offset = (player.origin[2] + 72) - self.origin[2];
			n_dist_sq = distancesquared(player.origin, self.origin);
			if(n_height_offset < n_lowest_height_offset)
			{
				n_lowest_height_offset = n_height_offset;
			}
			if(n_dist_sq < n_closest_dist_sq)
			{
				n_closest_dist_sq = n_dist_sq;
			}
			if(n_lowest_height_offset < (152 * -1))
			{
				var_a8dc514 = 1;
				continue;
			}
			if(abs(n_height_offset) < 96)
			{
				if(util::within_fov(self.origin, self.angles, player.origin, n_forward_view))
				{
					b_player_is_ahead = 1;
				}
			}
		}
		if(!var_a8dc514 && !b_player_is_ahead && n_closest_dist_sq > 2250000)
		{
			b_wait_for_player = 1;
		}
		if(!b_wait_for_player)
		{
			if(var_a8dc514)
			{
				self.n_speed = 35;
			}
			else
			{
				if(n_closest_dist_sq <= 562500 || b_player_is_ahead)
				{
					self.n_speed = 25;
				}
				else
				{
					self.n_speed = 5;
				}
			}
			if(level flag::get("drone_scanning"))
			{
				self vehicle::resume_path();
				level flag::clear("drone_scanning");
			}
		}
		else
		{
			self.n_speed = 0;
			self vehicle::pause_path();
			if(!level flag::get("drone_scanning"))
			{
				self thread function_517ced56(60, 90, 15, 50);
			}
		}
		self setspeed(self.n_speed, 35, 35);
		wait(0.05);
	}
}

/*
	Name: function_3c36d48d
	Namespace: mapping_drone
	Checksum: 0xE080B7F1
	Offset: 0xA10
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_3c36d48d()
{
	/#
		self endon(#"stop_speed_regulator");
		self endon(#"reached_end_node");
		while(true)
		{
			wait(1);
			switch(self.n_speed)
			{
				case 35:
				{
					iprintln("");
					break;
				}
				case 25:
				{
					iprintln("");
					break;
				}
				case 5:
				{
					iprintln("");
					break;
				}
				default:
				{
					iprintln("");
					break;
				}
			}
		}
	#/
}

/*
	Name: function_517ced56
	Namespace: mapping_drone
	Checksum: 0xFE7F8847
	Offset: 0xB08
	Size: 0x204
	Parameters: 4
	Flags: Linked
*/
function function_517ced56(n_yaw_left = 90, n_yaw_right = 90, n_pitch_down = 10, n_pitch_up = 30)
{
	level flag::set("drone_scanning");
	e_base = spawn("script_origin", self.origin);
	e_base.angles = self.angles;
	self linkto(e_base);
	v_base_look = self.angles;
	while(level flag::get("drone_scanning"))
	{
		v_look_offset = (randomfloatrange(n_pitch_down * -1, n_pitch_up), randomfloatrange(n_yaw_left * -1, n_yaw_right), 0);
		v_look_angles = v_base_look + v_look_offset;
		e_base rotateto(v_look_angles, 0.5, 0.2, 0.2);
		e_base waittill(#"rotatedone");
		wait(randomfloatrange(1, 2));
	}
	e_base delete();
}

/*
	Name: function_4f6daa65
	Namespace: mapping_drone
	Checksum: 0xCB3FE5E2
	Offset: 0xD18
	Size: 0x1BC
	Parameters: 1
	Flags: None
*/
function function_4f6daa65(b_on = 1)
{
	if(b_on)
	{
		self clientfield::set("extra_cam_ent", 1);
		foreach(player in level.activeplayers)
		{
			player.menu_pip = player openluimenu("drone_pip");
		}
	}
	else
	{
		foreach(player in level.activeplayers)
		{
			if(isdefined(player.menu_pip))
			{
				player thread close_menu_with_delay(player.menu_pip, 1.25);
				player.menu_pip = undefined;
			}
		}
		self clientfield::set("extra_cam_ent", 0);
	}
}

/*
	Name: close_menu_with_delay
	Namespace: mapping_drone
	Checksum: 0x4F0FF879
	Offset: 0xEE0
	Size: 0x5C
	Parameters: 2
	Flags: Linked, Private
*/
function private close_menu_with_delay(menuhandle, delay)
{
	self setluimenudata(menuhandle, "close_current_menu", 1);
	wait(delay);
	self closeluimenu(menuhandle);
}

