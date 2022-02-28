// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace vehicle_death;

/*
	Name: __init__sytem__
	Namespace: vehicle_death
	Checksum: 0xA2D3384B
	Offset: 0x450
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle_death", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle_death
	Checksum: 0x4CD01A4B
	Offset: 0x490
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	setdvar("debug_crash_type", -1);
}

/*
	Name: main
	Namespace: vehicle_death
	Checksum: 0xF31DF8C6
	Offset: 0x4C0
	Size: 0x630
	Parameters: 0
	Flags: Linked
*/
function main()
{
	self endon(#"nodeath_thread");
	while(isdefined(self))
	{
		self waittill(#"death", attacker, damagefromunderneath, weapon, point, dir);
		if(isdefined(self.death_enter_cb))
		{
			[[self.death_enter_cb]]();
		}
		if(isdefined(self.script_deathflag))
		{
			level flag::set(self.script_deathflag);
		}
		if(!isdefined(self.delete_on_death))
		{
			self thread play_death_audio();
		}
		if(!isdefined(self))
		{
			return;
		}
		self death_cleanup_level_variables();
		if(vehicle::is_corpse(self))
		{
			if(!(isdefined(self.dont_kill_riders) && self.dont_kill_riders))
			{
				self death_cleanup_riders();
			}
			self notify(#"delete_destructible");
			return;
		}
		self vehicle::lights_off();
		if(isdefined(level.vehicle_death_thread[self.vehicletype]))
		{
			thread [[level.vehicle_death_thread[self.vehicletype]]]();
		}
		if(!isdefined(self.delete_on_death))
		{
			thread death_radius_damage();
		}
		is_aircraft = isdefined(self.vehicleclass) && self.vehicleclass == "plane" || (isdefined(self.vehicleclass) && self.vehicleclass == "helicopter");
		if(!isdefined(self.destructibledef))
		{
			if(!is_aircraft && (!(self.vehicletype == "horse" || self.vehicletype == "horse_player" || self.vehicletype == "horse_player_low" || self.vehicletype == "horse_low" || self.vehicletype == "horse_axis")) && isdefined(self.deathmodel) && self.deathmodel != "")
			{
				self thread set_death_model(self.deathmodel, self.modelswapdelay);
			}
			if(!isdefined(self.delete_on_death) && (!isdefined(self.mantled) || !self.mantled) && !isdefined(self.nodeathfx))
			{
				thread death_fx();
			}
			if(isdefined(self.delete_on_death))
			{
				wait(0.05);
				if(self.disconnectpathonstop === 1)
				{
					self vehicle::disconnect_paths();
				}
				if(!(isdefined(self.no_free_on_death) && self.no_free_on_death))
				{
					self freevehicle();
					self.isacorpse = 1;
					wait(0.05);
					if(isdefined(self))
					{
						self notify(#"death_finished");
						self delete();
					}
				}
				continue;
			}
		}
		thread death_make_badplace(self.vehicletype);
		if(isdefined(level.vehicle_deathnotify) && isdefined(level.vehicle_deathnotify[self.vehicletype]))
		{
			level notify(level.vehicle_deathnotify[self.vehicletype], attacker);
		}
		if(target_istarget(self))
		{
			target_remove(self);
		}
		if(self.classname == "script_vehicle")
		{
			self thread death_jolt(self.vehicletype);
		}
		if(do_scripted_crash())
		{
			self thread death_update_crash(point, dir);
		}
		if(isdefined(self.turretweapon) && self.turretweapon != level.weaponnone)
		{
			self clearturrettarget();
		}
		self waittill_crash_done_or_stopped();
		if(isdefined(self))
		{
			while(isdefined(self) && isdefined(self.dontfreeme))
			{
				wait(0.05);
			}
			self notify(#"stop_looping_death_fx");
			self notify(#"death_finished");
			wait(0.05);
			if(isdefined(self))
			{
				if(vehicle::is_corpse(self))
				{
					continue;
				}
				if(!isdefined(self))
				{
					continue;
				}
				occupants = self getvehoccupants();
				if(isdefined(occupants) && occupants.size)
				{
					for(i = 0; i < occupants.size; i++)
					{
						self usevehicle(occupants[i], 0);
					}
				}
				if(!(isdefined(self.no_free_on_death) && self.no_free_on_death))
				{
					self freevehicle();
					self.isacorpse = 1;
				}
				if(self.modeldummyon)
				{
					self hide();
				}
			}
		}
	}
}

/*
	Name: do_scripted_crash
	Namespace: vehicle_death
	Checksum: 0x3E34D393
	Offset: 0xAF8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function do_scripted_crash()
{
	return !isdefined(self.do_scripted_crash) || (isdefined(self.do_scripted_crash) && self.do_scripted_crash);
}

/*
	Name: play_death_audio
	Namespace: vehicle_death
	Checksum: 0x41E563D8
	Offset: 0xB28
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function play_death_audio()
{
	if(isdefined(self) && (isdefined(self.vehicleclass) && self.vehicleclass == "helicopter"))
	{
		if(!isdefined(self.death_counter))
		{
			self.death_counter = 0;
		}
		if(self.death_counter == 0)
		{
			self.death_counter++;
			self playsound("exp_veh_helicopter_hit");
		}
	}
}

/*
	Name: play_spinning_plane_sound
	Namespace: vehicle_death
	Checksum: 0x60D9FA49
	Offset: 0xBB0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function play_spinning_plane_sound()
{
	self playloopsound("veh_drone_spin", 0.05);
	level util::waittill_any("crash_move_done", "death");
	self stoploopsound(0.02);
}

/*
	Name: set_death_model
	Namespace: vehicle_death
	Checksum: 0xDCA0F9B2
	Offset: 0xC30
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function set_death_model(smodel, fdelay)
{
	if(!isdefined(smodel))
	{
		return;
	}
	if(isdefined(fdelay) && fdelay > 0)
	{
		wait(fdelay);
	}
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.deathmodel_attached))
	{
		return;
	}
	emodel = vehicle::get_dummy();
	if(!isdefined(emodel))
	{
		return;
	}
	if(!isdefined(emodel.death_anim) && isdefined(emodel.animtree))
	{
		emodel clearanim(%generic::root, 0);
	}
	if(smodel != self.vehmodel)
	{
		emodel setmodel(smodel);
		emodel setenemymodel(smodel);
	}
}

/*
	Name: aircraft_crash
	Namespace: vehicle_death
	Checksum: 0x1CFBC55
	Offset: 0xD48
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function aircraft_crash(point, dir)
{
	self.crashing = 1;
	if(isdefined(self.unloading))
	{
		while(isdefined(self.unloading))
		{
			wait(0.05);
		}
	}
	if(!isdefined(self))
	{
		return;
	}
	self thread aircraft_crash_move(point, dir);
	self thread play_spinning_plane_sound();
}

/*
	Name: helicopter_crash
	Namespace: vehicle_death
	Checksum: 0xBE09BF78
	Offset: 0xDD8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function helicopter_crash(point, dir)
{
	self.crashing = 1;
	self thread play_crashing_loop();
	if(isdefined(self.unloading))
	{
		while(isdefined(self.unloading))
		{
			wait(0.05);
		}
	}
	if(!isdefined(self))
	{
		return;
	}
	self thread helicopter_crash_movement(point, dir);
}

/*
	Name: helicopter_crash_movement
	Namespace: vehicle_death
	Checksum: 0x93541DD2
	Offset: 0xE60
	Size: 0x4B6
	Parameters: 2
	Flags: Linked
*/
function helicopter_crash_movement(point, dir)
{
	self endon(#"crash_done");
	self cancelaimove();
	self clearvehgoalpos();
	if(isdefined(level.heli_crash_smoke_trail_fx))
	{
		if(issubstr(self.vehicletype, "v78"))
		{
			playfxontag(level.heli_crash_smoke_trail_fx, self, "tag_origin");
		}
		else
		{
			if(self.vehicletype == "drone_firescout_axis" || self.vehicletype == "drone_firescout_isi")
			{
				playfxontag(level.heli_crash_smoke_trail_fx, self, "tag_main_rotor");
			}
			else
			{
				playfxontag(level.heli_crash_smoke_trail_fx, self, "tag_engine_left");
			}
		}
	}
	crash_zones = struct::get_array("heli_crash_zone", "targetname");
	if(crash_zones.size > 0)
	{
		best_dist = 99999;
		best_idx = -1;
		if(isdefined(self.a_crash_zones))
		{
			crash_zones = self.a_crash_zones;
		}
		for(i = 0; i < crash_zones.size; i++)
		{
			vec_to_crash_zone = crash_zones[i].origin - self.origin;
			vec_to_crash_zone = (vec_to_crash_zone[0], vec_to_crash_zone[1], 0);
			dist = length(vec_to_crash_zone);
			vec_to_crash_zone = vec_to_crash_zone / dist;
			veloctiy_scale = vectordot(self.velocity, vec_to_crash_zone) * -1;
			dist = dist + (500 * veloctiy_scale);
			if(dist < best_dist)
			{
				best_dist = dist;
				best_idx = i;
			}
		}
		if(best_idx != -1)
		{
			self.crash_zone = crash_zones[best_idx];
			self thread helicopter_crash_zone_accel(dir);
		}
	}
	else
	{
		if(isdefined(dir))
		{
			dir = vectornormalize(dir);
		}
		else
		{
			dir = (1, 0, 0);
		}
		side_dir = vectorcross(dir, (0, 0, 1));
		side_dir_mag = randomfloatrange(-500, 500);
		side_dir_mag = side_dir_mag + (math::sign(side_dir_mag) * 60);
		side_dir = side_dir * side_dir_mag;
		side_dir = side_dir + vectorscale((0, 0, 1), 150);
		self setphysacceleration((randomintrange(-500, 500), randomintrange(-500, 500), -1000));
		self setvehvelocity(self.velocity + side_dir);
		self thread helicopter_crash_accel();
		if(isdefined(point))
		{
			self thread helicopter_crash_rotation(point, dir);
		}
		else
		{
			self thread helicopter_crash_rotation(self.origin, dir);
		}
	}
	self thread crash_collision_test();
	wait(15);
	if(isdefined(self))
	{
		self notify(#"crash_done");
	}
}

/*
	Name: helicopter_crash_accel
	Namespace: vehicle_death
	Checksum: 0xE91642B0
	Offset: 0x1320
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function helicopter_crash_accel()
{
	self endon(#"crash_done");
	self endon(#"crash_move_done");
	self endon(#"death");
	if(!isdefined(self.crash_accel))
	{
		self.crash_accel = randomfloatrange(50, 80);
	}
	while(isdefined(self))
	{
		self setvehvelocity(self.velocity + (anglestoup(self.angles) * self.crash_accel));
		wait(0.1);
	}
}

/*
	Name: helicopter_crash_rotation
	Namespace: vehicle_death
	Checksum: 0x40006202
	Offset: 0x13D0
	Size: 0x388
	Parameters: 2
	Flags: Linked
*/
function helicopter_crash_rotation(point, dir)
{
	self endon(#"crash_done");
	self endon(#"crash_move_done");
	self endon(#"death");
	start_angles = self.angles;
	start_angles = (start_angles[0] + 10, start_angles[1], start_angles[2]);
	start_angles = (start_angles[0], start_angles[1], start_angles[2] + 10);
	ang_vel = self getangularvelocity();
	ang_vel = (0, ang_vel[1] * randomfloatrange(2, 3), 0);
	self setangularvelocity(ang_vel);
	point_2d = (point[0], point[1], self.origin[2]);
	torque = (0, randomintrange(90, 180), 0);
	if(self getangularvelocity()[1] < 0)
	{
		torque = torque * -1;
	}
	if(distance(self.origin, point_2d) > 5)
	{
		local_hit_point = point_2d - self.origin;
		dir_2d = (dir[0], dir[1], 0);
		if(length(dir_2d) > 0.01)
		{
			dir_2d = vectornormalize(dir_2d);
			torque = vectorcross(vectornormalize(local_hit_point), dir);
			torque = (0, 0, torque[2]);
			torque = vectornormalize(torque);
			torque = (0, torque[2] * 180, 0);
		}
	}
	while(true)
	{
		ang_vel = self getangularvelocity();
		ang_vel = ang_vel + (torque * 0.05);
		if(ang_vel[1] < (360 * -1))
		{
			ang_vel = (ang_vel[0], 360 * -1, ang_vel[2]);
		}
		else if(ang_vel[1] > 360)
		{
			ang_vel = (ang_vel[0], 360, ang_vel[2]);
		}
		self setangularvelocity(ang_vel);
		wait(0.05);
	}
}

/*
	Name: helicopter_crash_zone_accel
	Namespace: vehicle_death
	Checksum: 0x31B6E14B
	Offset: 0x1760
	Size: 0x640
	Parameters: 1
	Flags: Linked
*/
function helicopter_crash_zone_accel(dir)
{
	self endon(#"crash_done");
	self endon(#"crash_move_done");
	torque = (0, randomintrange(90, 150), 0);
	ang_vel = self getangularvelocity();
	torque = torque * math::sign(ang_vel[1]);
	/#
		if(isdefined(self.crash_zone.height))
		{
			self.crash_zone.height = 0;
		}
	#/
	if(abs(self.angles[2]) < 3)
	{
		self.angles = (self.angles[0], self.angles[1], randomintrange(3, 6) * math::sign(self.angles[2]));
	}
	is_vtol = issubstr(self.vehicletype, "v78");
	if(is_vtol)
	{
		torque = torque * 0.3;
	}
	while(isdefined(self))
	{
		/#
			assert(isdefined(self.crash_zone));
		#/
		dist = distance2d(self.origin, self.crash_zone.origin);
		if(dist < self.crash_zone.radius)
		{
			self setphysacceleration(vectorscale((0, 0, -1), 400));
			/#
				circle(self.crash_zone.origin + (0, 0, self.crash_zone.height), self.crash_zone.radius, (0, 1, 0), 0, 2000);
			#/
			self.crash_accel = 0;
		}
		else
		{
			self setphysacceleration(vectorscale((0, 0, -1), 50));
			/#
				circle(self.crash_zone.origin + (0, 0, self.crash_zone.height), self.crash_zone.radius, (1, 0, 0), 0, 2);
			#/
		}
		self.crash_vel = self.crash_zone.origin - self.origin;
		self.crash_vel = (self.crash_vel[0], self.crash_vel[1], 0);
		self.crash_vel = vectornormalize(self.crash_vel);
		self.crash_vel = self.crash_vel * (self getmaxspeed() * 0.5);
		if(is_vtol)
		{
			self.crash_vel = self.crash_vel * 0.5;
		}
		crash_vel_forward = (anglestoup(self.angles) * self getmaxspeed()) * 2;
		crash_vel_forward = (crash_vel_forward[0], crash_vel_forward[1], 0);
		self.crash_vel = self.crash_vel + crash_vel_forward;
		vel_x = difftrack(self.crash_vel[0], self.velocity[0], 1, 0.1);
		vel_y = difftrack(self.crash_vel[1], self.velocity[1], 1, 0.1);
		vel_z = difftrack(self.crash_vel[2], self.velocity[2], 1, 0.1);
		self setvehvelocity((vel_x, vel_y, vel_z));
		ang_vel = self getangularvelocity();
		ang_vel = (0, ang_vel[1], 0);
		ang_vel = ang_vel + (torque * 0.1);
		max_angluar_vel = 200;
		if(is_vtol)
		{
			max_angluar_vel = 100;
		}
		if(ang_vel[1] < (max_angluar_vel * -1))
		{
			ang_vel = (ang_vel[0], max_angluar_vel * -1, ang_vel[2]);
		}
		else if(ang_vel[1] > max_angluar_vel)
		{
			ang_vel = (ang_vel[0], max_angluar_vel, ang_vel[2]);
		}
		self setangularvelocity(ang_vel);
		wait(0.1);
	}
}

/*
	Name: helicopter_collision
	Namespace: vehicle_death
	Checksum: 0x4790C3D
	Offset: 0x1DA8
	Size: 0xDA
	Parameters: 0
	Flags: None
*/
function helicopter_collision()
{
	self endon(#"crash_done");
	while(true)
	{
		self waittill(#"veh_collision", velocity, normal);
		ang_vel = self getangularvelocity() * 0.5;
		self setangularvelocity(ang_vel);
		if(normal[2] < 0.7)
		{
			self setvehvelocity(self.velocity + (normal * 70));
		}
		else
		{
			self notify(#"crash_done");
		}
	}
}

/*
	Name: play_crashing_loop
	Namespace: vehicle_death
	Checksum: 0x34BD476F
	Offset: 0x1E90
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function play_crashing_loop()
{
	ent = spawn("script_origin", self.origin);
	ent linkto(self);
	ent playloopsound("exp_heli_crash_loop");
	self util::waittill_any("death", "snd_impact");
	ent delete();
}

/*
	Name: helicopter_explode
	Namespace: vehicle_death
	Checksum: 0x360CAF15
	Offset: 0x1F48
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function helicopter_explode(delete_me)
{
	self endon(#"death");
	self vehicle::do_death_fx();
	if(isdefined(delete_me) && delete_me == 1)
	{
		self delete();
	}
	self thread set_death_model(self.deathmodel, self.modelswapdelay);
}

/*
	Name: aircraft_crash_move
	Namespace: vehicle_death
	Checksum: 0xA1CBE6CD
	Offset: 0x1FD8
	Size: 0x5A8
	Parameters: 2
	Flags: Linked
*/
function aircraft_crash_move(point, dir)
{
	self endon(#"crash_move_done");
	self endon(#"death");
	self thread crash_collision_test();
	self clearvehgoalpos();
	self cancelaimove();
	self setrotorspeed(0.2);
	if(isdefined(self) && isdefined(self.vehicletype))
	{
		b_custom_deathmodel_setup = 1;
		switch(self.vehicletype)
		{
			default:
			{
				b_custom_deathmodel_setup = 0;
				break;
			}
		}
		if(b_custom_deathmodel_setup)
		{
			self.deathmodel_attached = 1;
		}
	}
	ang_vel = self getangularvelocity();
	ang_vel = (0, 0, 0);
	self setangularvelocity(ang_vel);
	nodes = self getvehicleavoidancenodes(10000);
	closest_index = -1;
	best_dist = 999999;
	if(nodes.size > 0)
	{
		for(i = 0; i < nodes.size; i++)
		{
			dir = vectornormalize(nodes[i] - self.origin);
			forward = anglestoforward(self.angles);
			dot = vectordot(dir, forward);
			if(dot < 0)
			{
				continue;
			}
			dist = distance2d(self.origin, nodes[i]);
			if(dist < best_dist)
			{
				best_dist = dist;
				closest_index = i;
			}
		}
		if(closest_index >= 0)
		{
			o = nodes[closest_index];
			o = (o[0], o[1], self.origin[2]);
			dir = vectornormalize(o - self.origin);
			self setvehvelocity(self.velocity + (dir * 2000));
		}
		else
		{
			self setvehvelocity((self.velocity + (anglestoright(self.angles) * (randomintrange(-1000, 1000)))) + (0, 0, randomintrange(0, 1500)));
		}
	}
	else
	{
		self setvehvelocity((self.velocity + (anglestoright(self.angles) * (randomintrange(-1000, 1000)))) + (0, 0, randomintrange(0, 1500)));
	}
	self thread delay_set_gravity(randomfloatrange(1.5, 3));
	torque = (0, randomintrange(-90, 90), randomintrange(90, 720));
	if(randomint(100) < 50)
	{
		torque = (torque[0], torque[1], torque[2] * -1);
	}
	while(isdefined(self))
	{
		ang_vel = self getangularvelocity();
		ang_vel = ang_vel + (torque * 0.05);
		if(ang_vel[2] < (500 * -1))
		{
			ang_vel = (ang_vel[0], ang_vel[1], 500 * -1);
		}
		else if(ang_vel[2] > 500)
		{
			ang_vel = (ang_vel[0], ang_vel[1], 500);
		}
		self setangularvelocity(ang_vel);
		wait(0.05);
	}
}

/*
	Name: delay_set_gravity
	Namespace: vehicle_death
	Checksum: 0x5CEA5205
	Offset: 0x2588
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function delay_set_gravity(delay)
{
	self endon(#"crash_move_done");
	self endon(#"death");
	wait(delay);
	self setphysacceleration((randomintrange(-1600, 1600), randomintrange(-1600, 1600), -1600));
}

/*
	Name: helicopter_crash_move
	Namespace: vehicle_death
	Checksum: 0x56026486
	Offset: 0x2608
	Size: 0x378
	Parameters: 2
	Flags: None
*/
function helicopter_crash_move(point, dir)
{
	self endon(#"crash_move_done");
	self endon(#"death");
	self thread crash_collision_test();
	self cancelaimove();
	self clearvehgoalpos();
	self setturningability(0);
	self setphysacceleration(vectorscale((0, 0, -1), 800));
	vel = self.velocity;
	dir = vectornormalize(dir);
	ang_vel = self getangularvelocity();
	ang_vel = (0, ang_vel[1] * randomfloatrange(1, 3), 0);
	self setangularvelocity(ang_vel);
	point_2d = (point[0], point[1], self.origin[2]);
	torque = vectorscale((0, 1, 0), 720);
	if(distance(self.origin, point_2d) > 5)
	{
		local_hit_point = point_2d - self.origin;
		dir_2d = (dir[0], dir[1], 0);
		if(length(dir_2d) > 0.01)
		{
			dir_2d = vectornormalize(dir_2d);
			torque = vectorcross(vectornormalize(local_hit_point), dir);
			torque = (0, 0, torque[2]);
			torque = vectornormalize(torque);
			torque = (0, torque[2] * 180, 0);
		}
	}
	while(true)
	{
		ang_vel = self getangularvelocity();
		ang_vel = ang_vel + (torque * 0.05);
		if(ang_vel[1] < (360 * -1))
		{
			ang_vel = (ang_vel[0], 360 * -1, ang_vel[2]);
		}
		else if(ang_vel[1] > 360)
		{
			ang_vel = (ang_vel[0], 360, ang_vel[2]);
		}
		self setangularvelocity(ang_vel);
		wait(0.05);
	}
}

/*
	Name: boat_crash
	Namespace: vehicle_death
	Checksum: 0xFBE3AB51
	Offset: 0x2988
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function boat_crash(point, dir)
{
	self.crashing = 1;
	if(isdefined(self.unloading))
	{
		while(isdefined(self.unloading))
		{
			wait(0.05);
		}
	}
	if(!isdefined(self))
	{
		return;
	}
	self thread boat_crash_movement(point, dir);
}

/*
	Name: boat_crash_movement
	Namespace: vehicle_death
	Checksum: 0xD69D1E48
	Offset: 0x2A00
	Size: 0x2C0
	Parameters: 2
	Flags: Linked
*/
function boat_crash_movement(point, dir)
{
	self endon(#"crash_move_done");
	self endon(#"death");
	self cancelaimove();
	self clearvehgoalpos();
	self setphysacceleration(vectorscale((0, 0, -1), 50));
	vel = self.velocity;
	dir = vectornormalize(dir);
	ang_vel = self getangularvelocity();
	ang_vel = (0, 0, 0);
	self setangularvelocity(ang_vel);
	torque = (randomintrange(-5, -3), 0, (randomintrange(0, 100) < 50 ? -5 : 5));
	self thread boat_crash_monitor(point, dir, 4);
	while(true)
	{
		ang_vel = self getangularvelocity();
		ang_vel = ang_vel + (torque * 0.05);
		if(ang_vel[1] < (360 * -1))
		{
			ang_vel = (ang_vel[0], 360 * -1, ang_vel[2]);
		}
		else if(ang_vel[1] > 360)
		{
			ang_vel = (ang_vel[0], 360, ang_vel[2]);
		}
		self setangularvelocity(ang_vel);
		velocity = self.velocity;
		velocity = (velocity[0] * 0.975, velocity[1], velocity[2]);
		velocity = (velocity[0], velocity[1] * 0.975, velocity[2]);
		self setvehvelocity(velocity);
		wait(0.05);
	}
}

/*
	Name: boat_crash_monitor
	Namespace: vehicle_death
	Checksum: 0xAD262DEA
	Offset: 0x2CC8
	Size: 0x5A
	Parameters: 3
	Flags: Linked
*/
function boat_crash_monitor(point, dir, crash_time)
{
	self endon(#"death");
	wait(crash_time);
	self notify(#"crash_move_done");
	self crash_stop();
	self notify(#"crash_done");
}

/*
	Name: crash_stop
	Namespace: vehicle_death
	Checksum: 0x5D209FC5
	Offset: 0x2D30
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function crash_stop()
{
	self endon(#"death");
	self setphysacceleration((0, 0, 0));
	self setrotorspeed(0);
	speed = self getspeedmph();
	while(speed > 2)
	{
		velocity = self.velocity;
		velocity = velocity * 0.9;
		self setvehvelocity(velocity);
		angular_velocity = self getangularvelocity();
		angular_velocity = angular_velocity * 0.9;
		self setangularvelocity(angular_velocity);
		speed = self getspeedmph();
		wait(0.05);
	}
	self setvehvelocity((0, 0, 0));
	self setangularvelocity((0, 0, 0));
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
}

/*
	Name: crash_collision_test
	Namespace: vehicle_death
	Checksum: 0x77E5CBFE
	Offset: 0x2ED8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function crash_collision_test()
{
	self endon(#"death");
	self waittill(#"veh_collision", velocity, normal);
	self helicopter_explode();
	self notify(#"crash_move_done");
	if(normal[2] > 0.7)
	{
		forward = anglestoforward(self.angles);
		right = vectorcross(normal, forward);
		desired_forward = vectorcross(right, normal);
		self setphysangles(vectortoangles(desired_forward));
		self crash_stop();
		self notify(#"crash_done");
	}
	else
	{
		wait(0.05);
		self delete();
	}
}

/*
	Name: crash_path_check
	Namespace: vehicle_death
	Checksum: 0x97B039A5
	Offset: 0x3040
	Size: 0x1B2
	Parameters: 1
	Flags: Linked
*/
function crash_path_check(node)
{
	targ = node;
	for(search_depth = 5; isdefined(targ) && search_depth >= 0; search_depth--)
	{
		if(isdefined(targ.detoured) && targ.detoured == 0)
		{
			detourpath = vehicle::path_detour_get_detourpath(getvehiclenode(targ.target, "targetname"));
			if(isdefined(detourpath) && isdefined(detourpath.script_crashtype))
			{
				return true;
			}
		}
		if(isdefined(targ.target))
		{
			targ1 = getvehiclenode(targ.target, "targetname");
			if(isdefined(targ1) && isdefined(targ1.target) && isdefined(targ.targetname) && targ1.target == targ.targetname)
			{
				return false;
			}
			if(isdefined(targ1) && targ1 == node)
			{
				return false;
			}
			targ = targ1;
			continue;
		}
		targ = undefined;
	}
	return false;
}

/*
	Name: death_firesound
	Namespace: vehicle_death
	Checksum: 0x37DD2DAB
	Offset: 0x3200
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function death_firesound(sound)
{
	self thread sound::loop_on_tag(sound, undefined, 0);
	self util::waittill_any("fire_extinguish", "stop_crash_loop_sound");
	if(!isdefined(self))
	{
		return;
	}
	self notify("stop sound" + sound);
}

/*
	Name: death_fx
	Namespace: vehicle_death
	Checksum: 0x99A681CF
	Offset: 0x3278
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function death_fx()
{
	if(self vehicle::is_destructible())
	{
		return;
	}
	self util::explode_notify_wrapper();
	if(isdefined(self.do_death_fx))
	{
		self [[self.do_death_fx]]();
	}
	else
	{
		self vehicle::do_death_fx();
	}
}

/*
	Name: death_make_badplace
	Namespace: vehicle_death
	Checksum: 0x8674DF3E
	Offset: 0x32F0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function death_make_badplace(type)
{
	if(!isdefined(level.vehicle_death_badplace[type]))
	{
		return;
	}
	struct = level.vehicle_death_badplace[type];
	if(isdefined(struct.delay))
	{
		wait(struct.delay);
	}
	if(!isdefined(self))
	{
		return;
	}
	badplace_box("vehicle_kill_badplace", struct.duration, self.origin, struct.radius, "all");
}

/*
	Name: death_jolt
	Namespace: vehicle_death
	Checksum: 0x9B380FA3
	Offset: 0x33A0
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function death_jolt(type)
{
	self endon(#"death");
	if(isdefined(self.ignore_death_jolt) && self.ignore_death_jolt)
	{
		return;
	}
	self joltbody(self.origin + (23, 33, 64), 3);
	if(isdefined(self.death_anim))
	{
		self animscripted("death_anim", self.origin, self.angles, self.death_anim, "normal", %generic::root, 1, 0);
		self waittillmatch(#"death_anim");
	}
	else if(self.isphysicsvehicle)
	{
		num_launch_multiplier = 1;
		if(isdefined(self.physicslaunchdeathscale))
		{
			num_launch_multiplier = self.physicslaunchdeathscale;
		}
		self launchvehicle(vectorscale((0, 0, 1), 180) * num_launch_multiplier, (randomfloatrange(5, 10), randomfloatrange(-5, 5), 0), 1, 0, 1);
	}
}

/*
	Name: deathrollon
	Namespace: vehicle_death
	Checksum: 0x5449791F
	Offset: 0x3520
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function deathrollon()
{
	if(self.health > 0)
	{
		self.rollingdeath = 1;
	}
}

/*
	Name: deathrolloff
	Namespace: vehicle_death
	Checksum: 0x1B628B79
	Offset: 0x3548
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function deathrolloff()
{
	self.rollingdeath = undefined;
	self notify(#"deathrolloff");
}

/*
	Name: loop_fx_on_vehicle_tag
	Namespace: vehicle_death
	Checksum: 0x1043DC4E
	Offset: 0x3570
	Size: 0xBE
	Parameters: 3
	Flags: None
*/
function loop_fx_on_vehicle_tag(effect, looptime, tag)
{
	/#
		assert(isdefined(effect));
	#/
	/#
		assert(isdefined(tag));
	#/
	/#
		assert(isdefined(looptime));
	#/
	self endon(#"stop_looping_death_fx");
	while(isdefined(self))
	{
		playfxontag(effect, deathfx_ent(), tag);
		wait(looptime);
	}
}

/*
	Name: deathfx_ent
	Namespace: vehicle_death
	Checksum: 0xE7A1D4C
	Offset: 0x3638
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function deathfx_ent()
{
	if(!isdefined(self.deathfx_ent))
	{
		ent = spawn("script_model", (0, 0, 0));
		emodel = vehicle::get_dummy();
		ent setmodel(self.model);
		ent.origin = emodel.origin;
		ent.angles = emodel.angles;
		ent notsolid();
		ent hide();
		ent linkto(emodel);
		self.deathfx_ent = ent;
	}
	else
	{
		self.deathfx_ent setmodel(self.model);
	}
	return self.deathfx_ent;
}

/*
	Name: death_cleanup_level_variables
	Namespace: vehicle_death
	Checksum: 0x274BA33D
	Offset: 0x3770
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function death_cleanup_level_variables()
{
	script_linkname = self.script_linkname;
	targetname = self.targetname;
	if(isdefined(script_linkname))
	{
		arrayremovevalue(level.vehicle_link[script_linkname], self);
	}
	if(isdefined(self.script_vehiclespawngroup))
	{
		if(isdefined(level.vehicle_spawngroup[self.script_vehiclespawngroup]))
		{
			arrayremovevalue(level.vehicle_spawngroup[self.script_vehiclespawngroup], self);
			arrayremovevalue(level.vehicle_spawngroup[self.script_vehiclespawngroup], undefined);
		}
	}
	if(isdefined(self.script_vehiclestartmove))
	{
		arrayremovevalue(level.vehicle_startmovegroup[self.script_vehiclestartmove], self);
	}
	if(isdefined(self.script_vehiclegroupdelete))
	{
		arrayremovevalue(level.vehicle_deletegroup[self.script_vehiclegroupdelete], self);
	}
}

/*
	Name: death_cleanup_riders
	Namespace: vehicle_death
	Checksum: 0xD35C1ACA
	Offset: 0x38A8
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function death_cleanup_riders()
{
	if(isdefined(self.riders))
	{
		for(j = 0; j < self.riders.size; j++)
		{
			if(isdefined(self.riders[j]))
			{
				self.riders[j] delete();
			}
		}
	}
	if(vehicle::is_corpse(self))
	{
		self.riders = [];
	}
}

/*
	Name: death_radius_damage
	Namespace: vehicle_death
	Checksum: 0x65E7FA1D
	Offset: 0x3940
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function death_radius_damage(meansofdamage = "MOD_EXPLOSIVE")
{
	self endon(#"death");
	if(!isdefined(self) || self.abandoned === 1 || self.damage_on_death === 0 || self.radiusdamageradius <= 0)
	{
		return;
	}
	position = self.origin + vectorscale((0, 0, 1), 15);
	radius = self.radiusdamageradius;
	damagemax = self.radiusdamagemax;
	damagemin = self.radiusdamagemin;
	attacker = self;
	wait(0.05);
	if(isdefined(self))
	{
		self radiusdamage(position, radius, damagemax, damagemin, attacker, meansofdamage);
	}
}

/*
	Name: death_update_crash
	Namespace: vehicle_death
	Checksum: 0xC1A92822
	Offset: 0x3A60
	Size: 0x2F4
	Parameters: 2
	Flags: Linked
*/
function death_update_crash(point, dir)
{
	if(!isdefined(self.destructibledef))
	{
		if(isdefined(self.script_crashtypeoverride))
		{
			crashtype = self.script_crashtypeoverride;
		}
		else
		{
			if(isdefined(self.vehicleclass) && self.vehicleclass == "plane")
			{
				crashtype = "aircraft";
			}
			else
			{
				if(isdefined(self.vehicleclass) && self.vehicleclass == "helicopter")
				{
					crashtype = "helicopter";
				}
				else
				{
					if(isdefined(self.vehicleclass) && self.vehicleclass == "boat")
					{
						crashtype = "boat";
					}
					else
					{
						if(isdefined(self.currentnode) && crash_path_check(self.currentnode))
						{
							crashtype = "none";
						}
						else
						{
							crashtype = "tank";
						}
					}
				}
			}
		}
		if(crashtype == "aircraft")
		{
			self thread aircraft_crash(point, dir);
		}
		else
		{
			if(crashtype == "helicopter")
			{
				if(isdefined(self.script_nocorpse))
				{
					self thread helicopter_explode();
				}
				else
				{
					self thread helicopter_crash(point, dir);
				}
			}
			else
			{
				if(crashtype == "boat")
				{
					self thread boat_crash(point, dir);
				}
				else if(crashtype == "tank")
				{
					if(!isdefined(self.rollingdeath))
					{
						self vehicle::set_speed(0, 25, "Dead");
					}
					else
					{
						self waittill(#"deathrolloff");
						self vehicle::set_speed(0, 25, "Dead, finished path intersection");
					}
					wait(0.4);
					if(isdefined(self) && !vehicle::is_corpse(self))
					{
						self vehicle::set_speed(0, 10000, "deadstop");
						self notify(#"deadstop");
						if(self.disconnectpathonstop === 1)
						{
							self vehicle::disconnect_paths();
						}
						if(isdefined(self.tankgetout) && self.tankgetout > 0)
						{
							self waittill(#"animsdone");
						}
					}
				}
			}
		}
	}
}

/*
	Name: waittill_crash_done_or_stopped
	Namespace: vehicle_death
	Checksum: 0xE1B657A3
	Offset: 0x3D60
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function waittill_crash_done_or_stopped()
{
	self endon(#"death");
	if(isdefined(self) && (isdefined(self.vehicleclass) && self.vehicleclass == "plane" || (isdefined(self.vehicleclass) && self.vehicleclass == "boat")))
	{
		if(isdefined(self.crashing) && self.crashing == 1)
		{
			self waittill(#"crash_done");
		}
	}
	else
	{
		wait(0.2);
		if(self.isphysicsvehicle)
		{
			self clearvehgoalpos();
			self cancelaimove();
			stable_count = 0;
			while(stable_count < 3)
			{
				if(isdefined(self.velocity) && lengthsquared(self.velocity) > 1)
				{
					stable_count = 0;
				}
				else
				{
					stable_count++;
				}
				wait(0.3);
			}
			self vehicle::disconnect_paths();
		}
		else
		{
			while(isdefined(self) && self getspeedmph() > 0)
			{
				wait(0.3);
			}
		}
	}
}

/*
	Name: vehicle_damage_filter_damage_watcher
	Namespace: vehicle_death
	Checksum: 0xB9C422E9
	Offset: 0x3EE8
	Size: 0x1AC
	Parameters: 2
	Flags: Linked
*/
function vehicle_damage_filter_damage_watcher(driver, heavy_damage_threshold)
{
	self endon(#"death");
	self endon(#"exit_vehicle");
	self endon(#"end_damage_filter");
	if(!isdefined(heavy_damage_threshold))
	{
		heavy_damage_threshold = 100;
	}
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction, point, type, tagname, modelname, partname, weapon);
		earthquake(0.25, 0.15, self.origin, 512, self);
		driver playrumbleonentity("damage_light");
		time = gettime();
		if((time - level.n_last_damage_time) > 500)
		{
			level.n_hud_damage = 1;
			if(damage > heavy_damage_threshold)
			{
				driver playsound("veh_damage_filter_heavy");
			}
			else
			{
				driver playsound("veh_damage_filter_light");
			}
			level.n_last_damage_time = gettime();
		}
	}
}

/*
	Name: vehicle_damage_filter_exit_watcher
	Namespace: vehicle_death
	Checksum: 0x87BD53C7
	Offset: 0x40A0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function vehicle_damage_filter_exit_watcher(driver)
{
	self util::waittill_any("exit_vehicle", "death", "end_damage_filter");
}

/*
	Name: vehicle_damage_filter
	Namespace: vehicle_death
	Checksum: 0x7743D4CB
	Offset: 0x40E8
	Size: 0x188
	Parameters: 4
	Flags: Linked
*/
function vehicle_damage_filter(vision_set, heavy_damage_threshold, filterid = 0, b_use_player_damage = 0)
{
	self endon(#"death");
	self endon(#"exit_vehicle");
	self endon(#"end_damage_filter");
	driver = self getseatoccupant(0);
	if(!isdefined(self.damage_filter_init))
	{
		self.damage_filter_init = 1;
	}
	level.n_hud_damage = 0;
	level.n_last_damage_time = gettime();
	damagee = isdefined(b_use_player_damage) && (b_use_player_damage ? driver : self);
	damagee thread vehicle_damage_filter_damage_watcher(driver, heavy_damage_threshold);
	damagee thread vehicle_damage_filter_exit_watcher(driver);
	while(true)
	{
		if(isdefined(level.n_hud_damage) && level.n_hud_damage)
		{
			time = gettime();
			if((time - level.n_last_damage_time) > 500)
			{
				level.n_hud_damage = 0;
			}
		}
		wait(0.05);
	}
}

/*
	Name: flipping_shooting_death
	Namespace: vehicle_death
	Checksum: 0x5430D41C
	Offset: 0x4278
	Size: 0x19C
	Parameters: 2
	Flags: None
*/
function flipping_shooting_death(attacker, hitdir)
{
	if(isdefined(self.delete_on_death))
	{
		if(isdefined(self))
		{
			self delete();
		}
		return;
	}
	if(!isdefined(self))
	{
		return;
	}
	self endon(#"death");
	self death_cleanup_level_variables();
	self disableaimassist();
	self death_fx();
	self thread death_radius_damage();
	self thread set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	self vehicle::lights_off();
	self thread flipping_shooting_crash_movement(attacker, hitdir);
	self waittill(#"crash_done");
	while(isdefined(self.controlled) && self.controlled)
	{
		wait(0.05);
	}
	self delete();
}

/*
	Name: plane_crash
	Namespace: vehicle_death
	Checksum: 0x41E158CD
	Offset: 0x4420
	Size: 0x28C
	Parameters: 0
	Flags: Linked
*/
function plane_crash()
{
	self endon(#"death");
	self setphysacceleration(vectorscale((0, 0, -1), 1000));
	self.vehcheckforpredictedcrash = 1;
	forward = anglestoforward(self.angles);
	forward_mag = randomfloatrange(0, 300);
	forward_mag = forward_mag + (math::sign(forward_mag) * 400);
	forward = forward * forward_mag;
	new_vel = forward + (self.velocity * 0.2);
	ang_vel = self getangularvelocity();
	yaw_vel = randomfloatrange(0, 130) * math::sign(ang_vel[1]);
	yaw_vel = yaw_vel + (math::sign(yaw_vel) * 20);
	ang_vel = (randomfloatrange(-1, 1), yaw_vel, 0);
	roll_amount = (abs(ang_vel[1]) / 150) * 30;
	if(ang_vel[1] > 0)
	{
		roll_amount = roll_amount * -1;
	}
	self.angles = (self.angles[0], self.angles[1], roll_amount);
	ang_vel = (ang_vel[0], ang_vel[1], roll_amount * 0.9);
	self.velocity_rotation_frac = 1;
	self.crash_accel = randomfloatrange(65, 90);
	set_movement_and_accel(new_vel, ang_vel);
}

/*
	Name: barrel_rolling_crash
	Namespace: vehicle_death
	Checksum: 0xD0997231
	Offset: 0x46B8
	Size: 0x24C
	Parameters: 0
	Flags: Linked
*/
function barrel_rolling_crash()
{
	self endon(#"death");
	self setphysacceleration(vectorscale((0, 0, -1), 1000));
	self.vehcheckforpredictedcrash = 1;
	forward = anglestoforward(self.angles);
	forward_mag = randomfloatrange(0, 250);
	forward_mag = forward_mag + (math::sign(forward_mag) * 300);
	forward = forward * forward_mag;
	new_vel = forward + vectorscale((0, 0, 1), 70);
	ang_vel = self getangularvelocity();
	yaw_vel = randomfloatrange(0, 60) * math::sign(ang_vel[1]);
	yaw_vel = yaw_vel + (math::sign(yaw_vel) * 30);
	roll_vel = randomfloatrange(-200, 200);
	roll_vel = roll_vel + (math::sign(roll_vel) * 300);
	ang_vel = (randomfloatrange(-5, 5), yaw_vel, roll_vel);
	self.velocity_rotation_frac = 1;
	self.crash_accel = randomfloatrange(145, 210);
	self setphysacceleration(vectorscale((0, 0, -1), 250));
	set_movement_and_accel(new_vel, ang_vel);
}

/*
	Name: random_crash
	Namespace: vehicle_death
	Checksum: 0x7325C797
	Offset: 0x4910
	Size: 0x31C
	Parameters: 1
	Flags: Linked
*/
function random_crash(hitdir)
{
	self endon(#"death");
	self setphysacceleration(vectorscale((0, 0, -1), 1000));
	self.vehcheckforpredictedcrash = 1;
	if(!isdefined(hitdir))
	{
		hitdir = (1, 0, 0);
	}
	hitdir = vectornormalize(hitdir);
	side_dir = vectorcross(hitdir, (0, 0, 1));
	side_dir_mag = randomfloatrange(-280, 280);
	side_dir_mag = side_dir_mag + (math::sign(side_dir_mag) * 150);
	side_dir = side_dir * side_dir_mag;
	forward = anglestoforward(self.angles);
	forward_mag = randomfloatrange(0, 300);
	forward_mag = forward_mag + (math::sign(forward_mag) * 30);
	forward = forward * forward_mag;
	new_vel = (((self.velocity * 1.2) + forward) + side_dir) + vectorscale((0, 0, 1), 50);
	ang_vel = self getangularvelocity();
	ang_vel = (ang_vel[0] * 0.3, ang_vel[1], ang_vel[2] * 1.2);
	yaw_vel = randomfloatrange(0, 130) * math::sign(ang_vel[1]);
	yaw_vel = yaw_vel + (math::sign(yaw_vel) * 50);
	ang_vel = ang_vel + (randomfloatrange(-5, 5), yaw_vel, randomfloatrange(-18, 18));
	self.velocity_rotation_frac = randomfloatrange(0.3, 0.99);
	self.crash_accel = randomfloatrange(65, 90);
	set_movement_and_accel(new_vel, ang_vel);
}

/*
	Name: set_movement_and_accel
	Namespace: vehicle_death
	Checksum: 0x4B3E7008
	Offset: 0x4C38
	Size: 0x20E
	Parameters: 2
	Flags: Linked
*/
function set_movement_and_accel(new_vel, ang_vel)
{
	self death_fx();
	self thread death_radius_damage();
	self setvehvelocity(new_vel);
	self setangularvelocity(ang_vel);
	if(!isdefined(self.off))
	{
		self thread flipping_shooting_crash_accel();
	}
	self thread vehicle_ai::nudge_collision();
	self playsound("veh_wasp_dmg_hit");
	self vehicle::toggle_sounds(0);
	if(!isdefined(self.off))
	{
		self thread flipping_shooting_dmg_snd();
	}
	wait(0.1);
	if(randomint(100) < 40 && !isdefined(self.off) && self.variant !== "rocket")
	{
		self thread vehicle_ai::fire_for_time(randomfloatrange(0.7, 2));
	}
	result = self util::waittill_any_timeout(15, "crash_done");
	if(result === "crash_done")
	{
		self vehicle::do_death_dynents();
		self set_death_model(self.deathmodel, self.modelswapdelay);
	}
	else
	{
		self notify(#"crash_done");
	}
}

/*
	Name: flipping_shooting_crash_movement
	Namespace: vehicle_death
	Checksum: 0xAAD4F63D
	Offset: 0x4E50
	Size: 0x19A
	Parameters: 2
	Flags: Linked
*/
function flipping_shooting_crash_movement(attacker, hitdir)
{
	self endon(#"crash_done");
	self endon(#"death");
	self cancelaimove();
	self clearvehgoalpos();
	self clearlookatent();
	self setphysacceleration(vectorscale((0, 0, -1), 1000));
	self.vehcheckforpredictedcrash = 1;
	if(!isdefined(hitdir))
	{
		hitdir = (1, 0, 0);
	}
	hitdir = vectornormalize(hitdir);
	new_vel = self.velocity;
	self.crash_style = getdvarint("debug_crash_type");
	if(self.crash_style == -1)
	{
		self.crash_style = randomint(3);
	}
	switch(self.crash_style)
	{
		case 0:
		{
			barrel_rolling_crash();
			break;
		}
		case 1:
		{
			plane_crash();
			break;
		}
		default:
		{
			random_crash(hitdir);
		}
	}
}

/*
	Name: flipping_shooting_dmg_snd
	Namespace: vehicle_death
	Checksum: 0x3CBAE300
	Offset: 0x4FF8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function flipping_shooting_dmg_snd()
{
	dmg_ent = spawn("script_origin", self.origin);
	dmg_ent linkto(self);
	dmg_ent playloopsound("veh_wasp_dmg_loop");
	self util::waittill_any("crash_done", "death");
	dmg_ent stoploopsound(1);
	wait(2);
	dmg_ent delete();
}

/*
	Name: flipping_shooting_crash_accel
	Namespace: vehicle_death
	Checksum: 0x41466A4E
	Offset: 0x50D0
	Size: 0x300
	Parameters: 0
	Flags: Linked
*/
function flipping_shooting_crash_accel()
{
	self endon(#"crash_done");
	self endon(#"death");
	count = 0;
	prev_forward = anglestoforward(self.angles);
	prev_forward_vel = vectordot(self.velocity, prev_forward) * self.velocity_rotation_frac;
	if(prev_forward_vel < 0)
	{
		prev_forward_vel = 0;
	}
	while(true)
	{
		self setvehvelocity(self.velocity + (anglestoup(self.angles) * self.crash_accel));
		self.crash_accel = self.crash_accel * 0.98;
		new_velocity = self.velocity;
		new_velocity = new_velocity - (prev_forward * prev_forward_vel);
		forward = anglestoforward(self.angles);
		new_velocity = new_velocity + (forward * prev_forward_vel);
		prev_forward = forward;
		prev_forward_vel = vectordot(new_velocity, prev_forward) * self.velocity_rotation_frac;
		if(prev_forward_vel < 10)
		{
			new_velocity = new_velocity + (forward * 40);
			prev_forward_vel = 0;
		}
		self setvehvelocity(new_velocity);
		wait(0.1);
		count++;
		if((count % 8) == 0 && randomint(100) > 40)
		{
			if(self.velocity[2] > 130)
			{
				self.crash_accel = self.crash_accel * 0.75;
			}
			else if(self.velocity[2] < 40 && count < 60)
			{
				if(abs(self.angles[0]) > 35 || abs(self.angles[2]) > 35)
				{
					self.crash_accel = randomfloatrange(100, 150);
				}
				else
				{
					self.crash_accel = randomfloatrange(45, 70);
				}
			}
		}
	}
}

/*
	Name: death_fire_loop_audio
	Namespace: vehicle_death
	Checksum: 0xEC5F4FE7
	Offset: 0x53D8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function death_fire_loop_audio()
{
	sound_ent = spawn("script_origin", self.origin);
	sound_ent playloopsound("veh_qrdrone_death_fire_loop", 0.1);
	wait(11);
	sound_ent stoploopsound(1);
	sound_ent delete();
}

/*
	Name: freewhensafe
	Namespace: vehicle_death
	Checksum: 0x4091733C
	Offset: 0x5470
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function freewhensafe(time = 4)
{
	self thread delayedremove_thread(time, 0);
}

/*
	Name: deletewhensafe
	Namespace: vehicle_death
	Checksum: 0x884277C2
	Offset: 0x54B8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function deletewhensafe(time = 4)
{
	self thread delayedremove_thread(time, 1);
}

/*
	Name: delayedremove_thread
	Namespace: vehicle_death
	Checksum: 0xC9DAEF3B
	Offset: 0x5500
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function delayedremove_thread(time, shoulddelete)
{
	if(!isdefined(self))
	{
		return;
	}
	self endon(#"death");
	self endon(#"free_vehicle");
	if(shoulddelete === 1)
	{
		self setvehvelocity((0, 0, 0));
		self ghost();
		self notsolid();
	}
	util::waitfortimeandnetworkframe(time);
	if(shoulddelete === 1)
	{
		self delete();
	}
	else
	{
		self freevehicle();
	}
}

/*
	Name: cleanup
	Namespace: vehicle_death
	Checksum: 0x6DA5E86A
	Offset: 0x55E8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function cleanup()
{
	if(isdefined(self.cleanup_after_time))
	{
		wait(self.cleanup_after_time);
		if(isdefined(self))
		{
			self delete();
		}
	}
}

