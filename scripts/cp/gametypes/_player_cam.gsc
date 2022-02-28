// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace namespace_5f11fb0b;

/*
	Name: main
	Namespace: namespace_5f11fb0b
	Checksum: 0x42E2F60A
	Offset: 0x568
	Size: 0x94
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("toplayer", "player_cam_blur", 1, 1, "int");
	clientfield::register("toplayer", "player_cam_bubbles", 1, 1, "int");
	clientfield::register("toplayer", "player_cam_fire", 1, 1, "int");
}

/*
	Name: function_8e835895
	Namespace: namespace_5f11fb0b
	Checksum: 0xF50DF5CB
	Offset: 0x608
	Size: 0x3BC
	Parameters: 9
	Flags: Linked
*/
function function_8e835895(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	self endon(#"disconnect");
	if(getdvarint("test_cam") > 0)
	{
		value = getdvarint("test_cam");
		if(value == 1)
		{
			smeansofdeath = "MOD_BULLET";
		}
		else
		{
			if(value == 2)
			{
				smeansofdeath = "MOD_EXPLOSIVE";
			}
			else
			{
				if(value == 3)
				{
					smeansofdeath = "MOD_BURNED";
				}
				else
				{
					if(value == 4)
					{
						smeansofdeath = "MOD_DROWN";
					}
					else if(value == 5)
					{
						self thread function_fd6ad16(einflictor, attacker, idamage, weapon, vdir, shitloc);
						return;
					}
				}
			}
		}
	}
	if(smeansofdeath === "MOD_EXPLOSIVE" || smeansofdeath === "MOD_PROJECTILE" || smeansofdeath === "MOD_PROJECTILE_SPLASH" || smeansofdeath === "MOD_GRENADE" || smeansofdeath === "MOD_GRENADE_SPLASH")
	{
		self thread function_7a3707a6(einflictor, attacker, idamage, weapon, vdir, shitloc);
	}
	else
	{
		if(smeansofdeath === "MOD_BULLET" || smeansofdeath === "MOD_RIFLE_BULLET" || smeansofdeath === "MOD_PISTOL_BULLET")
		{
			self thread function_f05a5931(einflictor, attacker, idamage, weapon, vdir, shitloc);
		}
		else
		{
			if(smeansofdeath === "MOD_BURNED")
			{
				self thread function_1c006469(einflictor, attacker, idamage, weapon, vdir, shitloc);
			}
			else
			{
				if(smeansofdeath === "MOD_DROWN")
				{
					self thread function_514913aa(einflictor, attacker, idamage, weapon, vdir, shitloc);
				}
				else
				{
					if(isdefined(attacker) && attacker.classname == "trigger_hurt" && isdefined(attacker.script_noteworthy) && attacker.script_noteworthy == "fall_death")
					{
						self thread function_fd6ad16(einflictor, attacker, idamage, weapon, vdir, shitloc);
					}
					else
					{
						if(smeansofdeath === "MOD_MELEE" || smeansofdeath === "MOD_MELEE_WEAPON_BUTT")
						{
							self thread function_6e880b57(einflictor, attacker, idamage, weapon, vdir, shitloc);
						}
						else
						{
							self thread function_1e43c03b(einflictor, attacker, idamage, weapon, undefined, shitloc);
						}
					}
				}
			}
		}
	}
}

/*
	Name: function_812435e3
	Namespace: namespace_5f11fb0b
	Checksum: 0xF6CDC568
	Offset: 0x9D0
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function function_812435e3()
{
	self endon(#"disconnect");
	self thread util::screen_message_create_client("Press USE button to watch KillCam", undefined, undefined, 200, 10000);
	wait(3);
	self thread util::screen_message_delete_client();
}

/*
	Name: function_6eb06d8d
	Namespace: namespace_5f11fb0b
	Checksum: 0x4BDE5EC
	Offset: 0xA28
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function function_6eb06d8d(old_position, new_position)
{
	size = 10;
	height = size * 2;
	mins = (-1 * size, -1 * size, 0);
	maxs = (size, size, height);
	trace = physicstrace(old_position, new_position, mins, maxs, self);
	return trace;
}

/*
	Name: function_b1d0850f
	Namespace: namespace_5f11fb0b
	Checksum: 0xE46B84A8
	Offset: 0xAE8
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function function_b1d0850f(old_position, new_position)
{
	trace = function_6eb06d8d(old_position, new_position);
	return trace["position"];
}

/*
	Name: function_e2d94882
	Namespace: namespace_5f11fb0b
	Checksum: 0xB35B7462
	Offset: 0xB38
	Size: 0x56
	Parameters: 2
	Flags: Linked
*/
function function_e2d94882(old_position, new_position)
{
	trace = function_6eb06d8d(old_position, new_position);
	if(trace["fraction"] < 1)
	{
		return false;
	}
	return true;
}

/*
	Name: is_falling
	Namespace: namespace_5f11fb0b
	Checksum: 0xC800EAD1
	Offset: 0xB98
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function is_falling(position)
{
	return function_e2d94882(position, position + (vectorscale((0, 0, -1), 500)));
}

/*
	Name: function_c003e53f
	Namespace: namespace_5f11fb0b
	Checksum: 0x7D4A3F96
	Offset: 0xBD8
	Size: 0x97C
	Parameters: 11
	Flags: Linked
*/
function function_c003e53f(vdir, var_f120d111, var_f40ed68d, var_9aadeff9, var_933bfc9b, var_67ca400f, var_f06dc6a2, var_b633f381, lookdir, var_213955be, var_956c7382)
{
	self endon(#"disconnect");
	self endon(#"hash_d3468831");
	epsilon = getdvarint("movecamera_epsilon", 2);
	original_position = self getplayercamerapos();
	position = original_position;
	angles = self getplayerangles();
	angles = (0, absangleclamp360(angles[1]), absangleclamp360(angles[2]));
	forwarddir = anglestoforward(angles);
	vector = position + forwarddir;
	if(isdefined(vdir))
	{
		vdir = vdir * -1;
		target_angles = vectortoangles(vdir);
	}
	else
	{
		vdir = (forwarddir[0], forwarddir[1], forwarddir[2]);
		target_angles = vectortoangles(vdir);
		vdir = (forwarddir[0], forwarddir[1], -1);
		vdir = vectornormalize(vdir);
	}
	if(isdefined(lookdir))
	{
		target_angles = vectortoangles(lookdir);
	}
	if(!isdefined(var_f06dc6a2))
	{
		var_f06dc6a2 = absangleclamp360(target_angles[0]);
	}
	if(!isdefined(var_b633f381))
	{
		var_b633f381 = absangleclamp360(target_angles[2]);
	}
	target_angles = (var_f06dc6a2, absangleclamp360(target_angles[1]), var_b633f381);
	angles = (absangleclamp360(target_angles[0]), absangleclamp360(target_angles[1]), angleclamp180(target_angles[2]));
	if(isdefined(var_f40ed68d) && vdir[0] != 0)
	{
		var_505f8faa = 0;
	}
	else
	{
		var_f40ed68d = 0;
		var_933bfc9b = 0;
		var_505f8faa = 1;
	}
	if(isdefined(var_9aadeff9) && vdir[2] != 0)
	{
		var_582dff76 = 0;
	}
	else
	{
		var_9aadeff9 = 0;
		var_67ca400f = 0;
		var_582dff76 = 1;
	}
	forwardvec = (vdir[0], vdir[1], 0);
	forwardvec = vectornormalize(forwardvec);
	while(!(isdefined(var_505f8faa) && var_505f8faa && (isdefined(var_582dff76) && var_582dff76)))
	{
		if(!(isdefined(var_505f8faa) && var_505f8faa))
		{
			var_e79cd0f2 = vectorscale(forwardvec, var_933bfc9b);
			var_cdbed540 = length(var_e79cd0f2);
			var_206341c9 = position - original_position;
			var_3b8e30c5 = length((var_206341c9[0], var_206341c9[1], 0));
			if((var_3b8e30c5 + var_cdbed540) >= var_f40ed68d)
			{
				var_cdbed540 = var_f40ed68d - var_3b8e30c5;
				var_505f8faa = 1;
			}
			new_position = position - vectorscale(forwardvec, var_cdbed540);
			var_381dd463 = position - (vectorscale(forwardvec, var_cdbed540 + epsilon));
			if(function_e2d94882(position, var_381dd463))
			{
				position = new_position;
			}
			else
			{
				var_505f8faa = 1;
			}
		}
		if(!(isdefined(var_582dff76) && var_582dff76))
		{
			var_553c9550 = var_67ca400f;
			var_6775da6e = abs(original_position[2] - position[2]);
			if((var_6775da6e + var_553c9550) >= var_9aadeff9)
			{
				var_553c9550 = var_9aadeff9 - var_6775da6e;
				var_582dff76 = 1;
			}
			new_position = (position[0], position[1], position[2] - var_553c9550);
			var_381dd463 = (position[0], position[1], (position[2] - var_553c9550) - epsilon);
			if(function_e2d94882(position, var_381dd463))
			{
				position = new_position;
			}
			else
			{
				var_582dff76 = 1;
			}
		}
	}
	if(!function_e2d94882(original_position, position))
	{
		position = function_b1d0850f(original_position, position);
	}
	self cameraactivate(1);
	is_falling = is_falling(position);
	if(isdefined(var_213955be) && var_213955be || (!(isdefined(is_falling) && is_falling)))
	{
		if(var_f120d111 > 0)
		{
			self startcameratween(var_f120d111, 1);
			self camerasetposition(position, angles);
			wait(var_f120d111);
		}
		else
		{
			thread function_a0c37dda(position, angles, var_956c7382);
		}
	}
	if(isdefined(is_falling) && is_falling)
	{
		player_speed = self getvelocity()[2];
		var_2fedf129 = length(position - original_position);
		var_e25845de = var_2fedf129 * var_f120d111;
		player_speed = max(player_speed, var_e25845de);
		var_c0917add = getdvarint("move_max_falling_height", -2000);
		var_1f7dab73 = getdvarint("move_min_falling_speed", 500);
		var_b63780dc = function_b1d0850f(position, position + (0, 0, var_c0917add));
		var_ce9f61c5 = length(var_b63780dc - position);
		var_3be21125 = (-88, absangleclamp360(angles[1]), 0);
		var_d46b4656 = max(player_speed, var_1f7dab73);
		var_1c64d606 = var_ce9f61c5 / var_d46b4656;
		self camerasetposition(var_b63780dc, var_3be21125);
		self startcameratween(var_1c64d606, 1);
		wait(var_1c64d606);
		function_956c7382(var_b63780dc);
	}
}

/*
	Name: function_956c7382
	Namespace: namespace_5f11fb0b
	Checksum: 0x2C93FDAB
	Offset: 0x1560
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_956c7382(position)
{
	var_ceb19c17 = getdvarfloat("dc_quake_scale", 0.4);
	var_1b0dac7b = getdvarfloat("dc_quake_duration", 0.1);
	var_450561c5 = getdvarfloat("dc_quake_radius", 5);
	earthquake(var_ceb19c17, var_1b0dac7b, position, var_450561c5);
}

/*
	Name: function_a0c37dda
	Namespace: namespace_5f11fb0b
	Checksum: 0x9E2CF7A3
	Offset: 0x1620
	Size: 0x12C
	Parameters: 3
	Flags: Linked
*/
function function_a0c37dda(position, angles, var_956c7382)
{
	self endon(#"disconnect");
	var_12327db5 = getdvarfloat("dc_drop_length", 10);
	var_43c0c3c7 = position + (0, 0, var_12327db5);
	self camerasetposition(var_43c0c3c7, angles);
	wait(0.05);
	var_2e0ea125 = getdvarfloat("dc_drop_quickly_tween_time", 0.1);
	self camerasetposition(position, angles);
	self startcameratween(var_2e0ea125, 1);
	wait(var_2e0ea125);
	if(isdefined(var_956c7382) && var_956c7382)
	{
		function_956c7382(position);
	}
}

/*
	Name: function_22196132
	Namespace: namespace_5f11fb0b
	Checksum: 0x951206BC
	Offset: 0x1758
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function function_22196132()
{
	dot = vectordot(self getvelocity(), anglestoright(self.angles));
	if(dot > 0)
	{
		return 1;
	}
	return -1;
}

/*
	Name: function_f05a5931
	Namespace: namespace_5f11fb0b
	Checksum: 0xC88EB523
	Offset: 0x17C0
	Size: 0x1BE
	Parameters: 6
	Flags: Linked
*/
function function_f05a5931(einflictor, attacker, idamage, weapon, vdir, shitloc)
{
	self endon(#"disconnect");
	self clientfield::set_to_player("player_cam_blur", 1);
	var_67ca400f = getdvarfloat("cam_bullet_position_z_speed", 20);
	var_933bfc9b = getdvarfloat("cam_bullet_position_f_speed", 20);
	var_9aadeff9 = getdvarfloat("cam_bullet_max_z_length", 50);
	var_f40ed68d = getdvarfloat("cam_bullet_max_f_length", 50);
	end_wait = getdvarfloat("cam_bullet_end_wait", 2.75);
	sign = self function_22196132();
	thread function_c003e53f(vdir, 0, var_f40ed68d, var_9aadeff9, var_933bfc9b, var_67ca400f, undefined, 60 * sign, undefined, undefined, 1);
	self playrumbleonentity("damage_heavy");
	wait(end_wait);
	self notify(#"hash_d3468831");
}

/*
	Name: function_6e880b57
	Namespace: namespace_5f11fb0b
	Checksum: 0xEF110DB8
	Offset: 0x1988
	Size: 0x1B6
	Parameters: 6
	Flags: Linked
*/
function function_6e880b57(einflictor, attacker, idamage, weapon, vdir, shitloc)
{
	self endon(#"disconnect");
	self clientfield::set_to_player("player_cam_blur", 1);
	var_67ca400f = getdvarfloat("cam_bullet_position_z_speed", 20);
	var_933bfc9b = getdvarfloat("cam_bullet_position_f_speed", 20);
	var_9aadeff9 = getdvarfloat("cam_bullet_max_z_length", 50);
	var_f40ed68d = getdvarfloat("cam_bullet_max_f_length", 50);
	end_wait = getdvarfloat("cam_bullet_end_wait", 2.75);
	sign = self function_22196132();
	self playrumbleonentity("damage_heavy");
	thread function_c003e53f(vdir, 0, var_f40ed68d, var_9aadeff9, var_933bfc9b, var_67ca400f, undefined, 60 * sign);
	wait(end_wait);
	self notify(#"hash_d3468831");
}

/*
	Name: function_1e43c03b
	Namespace: namespace_5f11fb0b
	Checksum: 0x52EE63A5
	Offset: 0x1B48
	Size: 0x1BE
	Parameters: 6
	Flags: Linked
*/
function function_1e43c03b(einflictor, attacker, idamage, weapon, vdir, shitloc)
{
	self endon(#"disconnect");
	self clientfield::set_to_player("player_cam_blur", 1);
	sign = self function_22196132();
	var_67ca400f = getdvarfloat("cam_bullet_position_z_speed", 8);
	var_933bfc9b = getdvarfloat("cam_bullet_position_f_speed", 10);
	var_9aadeff9 = getdvarfloat("cam_bullet_max_z_length", 50);
	var_f40ed68d = getdvarfloat("cam_bullet_max_f_length", 50);
	end_wait = getdvarfloat("cam_bullet_end_wait", 2.75);
	thread function_c003e53f(undefined, 0, var_f40ed68d, var_9aadeff9, var_933bfc9b, var_67ca400f, undefined, 60 * sign, undefined, undefined, 1);
	self playrumbleonentity("damage_heavy");
	wait(end_wait);
	self notify(#"hash_d3468831");
}

/*
	Name: function_7a3707a6
	Namespace: namespace_5f11fb0b
	Checksum: 0x8C81E933
	Offset: 0x1D10
	Size: 0x32E
	Parameters: 6
	Flags: Linked
*/
function function_7a3707a6(einflictor, attacker, idamage, weapon, vdir, shitloc)
{
	self endon(#"disconnect");
	self clientfield::set_to_player("player_cam_blur", 1);
	var_67ca400f = getdvarfloat("cam_explosion_position_z_speed", 8);
	var_933bfc9b = getdvarfloat("cam_explosion_position_f_speed", 10);
	var_9aadeff9 = getdvarfloat("cam_explosion_max_z_length", 50);
	var_f40ed68d = getdvarfloat("cam_explosion_max_f_length", 100);
	var_91ba348e = getdvarfloat("cam_explosion_shake_vector_max", 1);
	lookdir = undefined;
	if(isdefined(attacker) && attacker != self)
	{
		var_7ec6acc8 = (attacker getabsmins() + attacker getabsmaxs()) * 0.5;
		lookdir = var_7ec6acc8 - self.origin;
		lookdir = vectornormalize(lookdir);
	}
	var_45918a20 = getdvarfloat("cam_explosion_fade_value", 0);
	var_638a5f4a = getdvarfloat("cam_explosion_first_fade_time", 0.4);
	var_4c824c0e = getdvarfloat("cam_explosion_second_fade_time", 0.4);
	var_c746fbe7 = getdvarfloat("cam_explosion_first_wait", 0.8);
	var_30ffabcb = getdvarfloat("cam_explosion_second_wait", 2);
	sign = self function_22196132();
	thread function_c003e53f(vdir, 0, var_f40ed68d, var_9aadeff9, var_933bfc9b, var_67ca400f, undefined, 60 * sign, lookdir, undefined, 1);
	self playrumbleonentity("damage_heavy");
	wait(var_30ffabcb);
	self notify(#"hash_d3468831");
}

/*
	Name: function_1c006469
	Namespace: namespace_5f11fb0b
	Checksum: 0xE8175737
	Offset: 0x2048
	Size: 0x196
	Parameters: 6
	Flags: Linked
*/
function function_1c006469(einflictor, attacker, idamage, weapon, vdir, shitloc)
{
	self endon(#"disconnect");
	self clientfield::set_to_player("player_cam_fire", 1);
	angles = self getplayerangles();
	forwarddir = anglestoforward(angles);
	var_9aadeff9 = getdvarfloat("cam_explosion_max_z_length", 50);
	var_67ca400f = getdvarfloat("cam_explosion_position_z_speed", 10);
	sign = self function_22196132();
	thread function_c003e53f(undefined, 0.2, 0, var_9aadeff9, 0, var_67ca400f, undefined, 50 * sign, forwarddir);
	wait(2);
	self.var_3c94a047 = 1;
	self thread lui::screen_fade(1, 1, 0, "white", 0);
	wait(1);
	self notify(#"hash_d3468831");
}

/*
	Name: function_514913aa
	Namespace: namespace_5f11fb0b
	Checksum: 0x40A51DEB
	Offset: 0x21E8
	Size: 0x17A
	Parameters: 6
	Flags: Linked
*/
function function_514913aa(einflictor, attacker, idamage, weapon, vdir, shitloc)
{
	self endon(#"disconnect");
	self clientfield::set_to_player("player_cam_bubbles", 1);
	angles = self getplayerangles();
	forwarddir = anglestoforward(angles);
	var_9aadeff9 = getdvarfloat("cam_explosion_max_z_length", 50);
	var_67ca400f = getdvarfloat("cam_explosion_position_z_speed", 10);
	thread function_c003e53f(undefined, 3, 0, var_9aadeff9, 0, var_67ca400f, undefined, undefined, forwarddir);
	var_253910ca = getdvarfloat("cam_bubbles_wait", 3);
	wait(var_253910ca);
	self clientfield::set_to_player("player_cam_bubbles", 0);
	self notify(#"hash_d3468831");
}

/*
	Name: function_fd6ad16
	Namespace: namespace_5f11fb0b
	Checksum: 0xA01DCA14
	Offset: 0x2370
	Size: 0x14E
	Parameters: 6
	Flags: Linked
*/
function function_fd6ad16(einflictor, attacker, idamage, weapon, vdir, shitloc)
{
	self endon(#"disconnect");
	var_67ca400f = getdvarfloat("cam_fall_position_z_speed", 500);
	var_933bfc9b = getdvarfloat("cam_fall_position_f_speed", 0);
	var_9aadeff9 = getdvarfloat("cam_fall_max_z_length", 500);
	var_f40ed68d = getdvarfloat("cam_fall_max_f_length", 0);
	end_wait = getdvarfloat("cam_fall_end_wait", 2);
	thread function_c003e53f(undefined, 1, undefined, var_9aadeff9, 0, var_67ca400f, -88, 1, undefined, 1, 1);
	wait(end_wait);
	self notify(#"hash_d3468831");
}

