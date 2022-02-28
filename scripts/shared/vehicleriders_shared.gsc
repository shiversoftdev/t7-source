// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace vehicle;

/*
	Name: __init__sytem__
	Namespace: vehicle
	Checksum: 0x740B637C
	Offset: 0x390
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicleriders", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle
	Checksum: 0xC57CF260
	Offset: 0x3D0
	Size: 0x524
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.vehiclerider_groups = [];
	level.vehiclerider_groups["all"] = "all";
	level.vehiclerider_groups["driver"] = "driver";
	level.vehiclerider_groups["passengers"] = "passenger";
	level.vehiclerider_groups["crew"] = "crew";
	level.vehiclerider_groups["gunners"] = "gunner";
	a_registered_fields = [];
	foreach(bundle in struct::get_script_bundles("vehicleriders"))
	{
		foreach(object in bundle.objects)
		{
			if(isstring(object.vehicleenteranim))
			{
				array::add(a_registered_fields, object.position + "_enter", 0);
			}
			if(isstring(object.vehicleexitanim))
			{
				array::add(a_registered_fields, object.position + "_exit", 0);
			}
			if(isstring(object.vehicleriderdeathanim))
			{
				array::add(a_registered_fields, object.position + "_death", 0);
			}
		}
	}
	foreach(str_clientfield in a_registered_fields)
	{
		clientfield::register("vehicle", str_clientfield, 1, 1, "counter");
	}
	level.vehiclerider_use_index = [];
	level.vehiclerider_use_index["driver"] = 0;
	for(i = 1; i <= 4; i++)
	{
		level.vehiclerider_use_index["gunner" + i] = i;
	}
	passengerindex = 1;
	for(i = 4 + 1; i <= 10; i++)
	{
		level.vehiclerider_use_index["passenger" + passengerindex] = i;
		passengerindex++;
	}
	foreach(s in struct::get_script_bundles("vehicleriders"))
	{
		if(!isdefined(s.lowexitheight))
		{
			s.lowexitheight = 0;
		}
		if(!isdefined(s.highexitlandheight))
		{
			s.highexitlandheight = 32;
		}
	}
	callback::on_vehicle_spawned(&on_vehicle_spawned);
	callback::on_ai_spawned(&on_ai_spawned);
	callback::on_vehicle_killed(&on_vehicle_killed);
}

/*
	Name: seat_position_to_index
	Namespace: vehicle
	Checksum: 0xB1F335AE
	Offset: 0x900
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function seat_position_to_index(str_position)
{
	return level.vehiclerider_use_index[str_position];
}

/*
	Name: on_vehicle_spawned
	Namespace: vehicle
	Checksum: 0xDF4F3292
	Offset: 0x920
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function on_vehicle_spawned()
{
	spawn_riders();
}

/*
	Name: on_ai_spawned
	Namespace: vehicle
	Checksum: 0xBC203BF2
	Offset: 0x940
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_ai_spawned()
{
	if(isvehicle(self))
	{
		self spawn_riders();
	}
}

/*
	Name: claim_position
	Namespace: vehicle
	Checksum: 0x7348F1C3
	Offset: 0x980
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function claim_position(vh, str_pos)
{
	array::add(vh.riders, self, 0);
	vh flagsys::set(str_pos + "occupied");
	self flagsys::set("vehiclerider");
	self thread _unclaim_position_on_death(vh, str_pos);
}

/*
	Name: unclaim_position
	Namespace: vehicle
	Checksum: 0xAF4AD136
	Offset: 0xA28
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function unclaim_position(vh, str_pos)
{
	arrayremovevalue(vh.riders, self);
	vh flagsys::clear(str_pos + "occupied");
	self flagsys::clear("vehiclerider");
}

/*
	Name: _unclaim_position_on_death
	Namespace: vehicle
	Checksum: 0x310E2164
	Offset: 0xAB0
	Size: 0x5C
	Parameters: 2
	Flags: Linked, Private
*/
function private _unclaim_position_on_death(vh, str_pos)
{
	vh endon(#"death");
	vh endon(str_pos + "occupied");
	self waittill(#"death");
	unclaim_position(vh, str_pos);
}

/*
	Name: find_next_open_position
	Namespace: vehicle
	Checksum: 0x7E098A4E
	Offset: 0xB18
	Size: 0x122
	Parameters: 1
	Flags: Linked
*/
function find_next_open_position(ai)
{
	foreach(s_rider in get_bundle_for_ai(ai).objects)
	{
		seat_index = seat_position_to_index(s_rider.position);
		if(seat_index <= 4)
		{
			if(self isvehicleseatoccupied(seat_index))
			{
				continue;
			}
		}
		if(!flagsys::get(s_rider.position + "occupied"))
		{
			return s_rider.position;
		}
	}
}

/*
	Name: spawn_riders
	Namespace: vehicle
	Checksum: 0xD8EB495A
	Offset: 0xC48
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function spawn_riders()
{
	self endon(#"death");
	self.riders = [];
	if(isdefined(self.script_vehicleride))
	{
		a_spawners = getspawnerarray(self.script_vehicleride, "script_vehicleride");
		foreach(sp in a_spawners)
		{
			ai_rider = sp spawner::spawn(1);
			if(isdefined(ai_rider))
			{
				ai_rider get_in(self, ai_rider.script_startingposition, 1);
			}
		}
	}
}

/*
	Name: get_bundle_for_ai
	Namespace: vehicle
	Checksum: 0x46BC1A5D
	Offset: 0xD70
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function get_bundle_for_ai(ai)
{
	vh = self;
	if(isdefined(ai.archetype) && ai.archetype == "robot")
	{
		bundle = vh get_robot_bundle();
	}
	else
	{
		bundle = vh get_bundle();
	}
	return bundle;
}

/*
	Name: get_rider_info
	Namespace: vehicle
	Checksum: 0xAB57FC29
	Offset: 0xE10
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function get_rider_info(vh, str_pos = "driver")
{
	ai = self;
	bundle = undefined;
	bundle = vh get_bundle_for_ai(ai);
	foreach(s_rider in bundle.objects)
	{
		if(s_rider.position == str_pos)
		{
			return s_rider;
		}
	}
}

/*
	Name: get_in
	Namespace: vehicle
	Checksum: 0xDC9C9654
	Offset: 0xF18
	Size: 0x5B4
	Parameters: 3
	Flags: Linked
*/
function get_in(vh, str_pos = vh find_next_open_position(self), b_teleport = 0)
{
	self endon(#"death");
	vh endon(#"death");
	/#
		assert(isdefined(str_pos), "");
	#/
	if(!isdefined(str_pos))
	{
		return;
	}
	if(!isdefined(vh.ignore_seat_check) || !vh.ignore_seat_check)
	{
		seat_index = level.vehiclerider_use_index[str_pos];
		if(seat_index <= 4)
		{
			seat_available = !vh isvehicleseatoccupied(seat_index);
			/#
				assert(seat_available, "");
			#/
			if(!seat_available)
			{
				return;
			}
		}
	}
	claim_position(vh, str_pos);
	if(!b_teleport && self flagsys::get("in_vehicle"))
	{
		get_out();
	}
	if(colors::is_color_ai())
	{
		colors::disable();
	}
	_init_rider(vh, str_pos);
	if(!b_teleport)
	{
		self animation::set_death_anim(self.rider_info.enterdeathanim);
		animation::reach(self.rider_info.enteranim, self.vehicle, self.rider_info.aligntag);
		if(isdefined(self.rider_info.vehicleenteranim))
		{
			vh clientfield::increment(self.rider_info.position + "_enter", 1);
			self setanim(self.rider_info.vehicleenteranim, 1, 0, 1);
		}
		self animation::play(self.rider_info.enteranim, self.vehicle, self.rider_info.aligntag);
	}
	if(isdefined(self.rider_info) && isdefined(self.rider_info.rideanim))
	{
		self thread animation::play(self.rider_info.rideanim, self.vehicle, self.rider_info.aligntag, 1, 0.2, 0.2, 0, 0, 0, 0);
	}
	else
	{
		if(!isdefined(level.vehiclerider_use_index[str_pos]))
		{
			/#
				assert("" + str_pos);
			#/
		}
		else
		{
			if(isdefined(self.rider_info))
			{
				v_tag_pos = vh gettagorigin(self.rider_info.aligntag);
				v_tag_ang = vh gettagangles(self.rider_info.aligntag);
				if(isdefined(v_tag_pos))
				{
					self forceteleport(v_tag_pos, v_tag_ang);
				}
			}
			else
			{
				/#
					errormsg("");
				#/
			}
		}
	}
	if(isactor(self))
	{
		self pathmode("dont move");
		self.disableammodrop = 1;
		self.dontdropweapon = 1;
	}
	if(isdefined(level.vehiclerider_use_index[str_pos]))
	{
		if(!isdefined(self.vehicle.ignore_seat_check) || !self.vehicle.ignore_seat_check)
		{
			seat_index = level.vehiclerider_use_index[str_pos];
			if(seat_index <= 4)
			{
				if(self.vehicle isvehicleseatoccupied(seat_index))
				{
					get_out();
					return;
				}
			}
		}
		self.vehicle usevehicle(self, level.vehiclerider_use_index[str_pos]);
	}
	self flagsys::set("in_vehicle");
	self thread handle_rider_death();
}

/*
	Name: handle_rider_death
	Namespace: vehicle
	Checksum: 0xB9B42575
	Offset: 0x14D8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function handle_rider_death()
{
	self endon(#"exiting_vehicle");
	self.vehicle endon(#"death");
	if(isdefined(self.rider_info.ridedeathanim))
	{
		self animation::set_death_anim(self.rider_info.ridedeathanim);
	}
	self waittill(#"death");
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.vehicle) && isdefined(self.rider_info) && isdefined(self.rider_info.vehicleriderdeathanim))
	{
		self.vehicle clientfield::increment(self.rider_info.position + "_death", 1);
		self.vehicle setanimknobrestart(self.rider_info.vehicleriderdeathanim, 1, 0, 1);
	}
}

/*
	Name: delete_rider_asap
	Namespace: vehicle
	Checksum: 0xEE273B79
	Offset: 0x15E8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function delete_rider_asap(entity)
{
	wait(0.05);
	if(isdefined(entity))
	{
		entity delete();
	}
}

/*
	Name: kill_rider
	Namespace: vehicle
	Checksum: 0xF7C79348
	Offset: 0x1628
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function kill_rider(entity)
{
	if(isdefined(entity))
	{
		if(isalive(entity) && !gibserverutils::isgibbed(entity, 2))
		{
			if(entity isplayinganimscripted())
			{
				entity stopanimscripted();
			}
			if(getdvarint("tu1_vehicleRidersInvincibility", 1))
			{
				util::stop_magic_bullet_shield(entity);
			}
			gibserverutils::gibleftarm(entity);
			gibserverutils::gibrightarm(entity);
			gibserverutils::giblegs(entity);
			gibserverutils::annihilate(entity);
			entity unlink();
			entity kill();
		}
		entity ghost();
		level thread delete_rider_asap(entity);
	}
}

/*
	Name: on_vehicle_killed
	Namespace: vehicle
	Checksum: 0xF36B70D7
	Offset: 0x17A8
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function on_vehicle_killed(params)
{
	if(isdefined(self.riders))
	{
		foreach(rider in self.riders)
		{
			kill_rider(rider);
		}
	}
}

/*
	Name: is_seat_available
	Namespace: vehicle
	Checksum: 0xA56F469F
	Offset: 0x1858
	Size: 0xCE
	Parameters: 2
	Flags: Linked
*/
function is_seat_available(vh, str_pos)
{
	if(vh flagsys::get(str_pos + "occupied"))
	{
		return false;
	}
	if(anglestoup(vh.angles)[2] < 0.3)
	{
		return false;
	}
	seat_index = seat_position_to_index(str_pos);
	if(seat_index <= 4)
	{
		if(vh isvehicleseatoccupied(seat_index))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: can_get_in
	Namespace: vehicle
	Checksum: 0xCBCE2E0A
	Offset: 0x1930
	Size: 0x116
	Parameters: 2
	Flags: Linked
*/
function can_get_in(vh, str_pos)
{
	if(!is_seat_available(vh, str_pos))
	{
		return false;
	}
	rider_info = self get_rider_info(vh, str_pos);
	v_tag_org = vh gettagorigin(rider_info.aligntag);
	v_tag_ang = vh gettagangles(rider_info.aligntag);
	v_enter_pos = getstartorigin(v_tag_org, v_tag_ang, rider_info.enteranim);
	if(!self findpath(self.origin, v_enter_pos))
	{
		return false;
	}
	return true;
}

/*
	Name: get_out
	Namespace: vehicle
	Checksum: 0xD65708D8
	Offset: 0x1A50
	Size: 0x3CA
	Parameters: 1
	Flags: Linked
*/
function get_out(str_mode)
{
	ai = self;
	self endon(#"death");
	self notify(#"exiting_vehicle");
	/#
		assert(isalive(self), "");
	#/
	/#
		assert(isdefined(self.vehicle), "");
	#/
	if(isdefined(self.vehicle.vehicleclass) && self.vehicle.vehicleclass == "helicopter" || (isdefined(self.vehicle.vehicleclass) && self.vehicle.vehicleclass == "plane"))
	{
		if(!isdefined(str_mode))
		{
			str_mode = "variable";
		}
	}
	else if(!isdefined(str_mode))
	{
		str_mode = "ground";
	}
	bundle = self.vehicle get_bundle_for_ai(ai);
	n_hover_height = bundle.lowexitheight;
	if(isdefined(self.rider_info.vehicleexitanim))
	{
		self.vehicle clientfield::increment(self.rider_info.position + "_exit", 1);
		self.vehicle setanim(self.rider_info.vehicleexitanim, 1, 0, 1);
	}
	switch(str_mode)
	{
		case "ground":
		{
			exit_ground();
			break;
		}
		case "low":
		{
			exit_low();
			break;
		}
		case "variable":
		{
			exit_variable();
			break;
		}
		default:
		{
			/#
				assertmsg("");
			#/
		}
	}
	if(isactor(self))
	{
		self pathmode("move allowed");
		self.disableammodrop = 0;
		self.dontdropweapon = 0;
	}
	if(isdefined(self.vehicle))
	{
		unclaim_position(self.vehicle, self.rider_info.position);
		if(isdefined(level.vehiclerider_use_index[self.rider_info.position]) && self flagsys::get("in_vehicle"))
		{
			self.vehicle usevehicle(self, level.vehiclerider_use_index[self.rider_info.position]);
		}
	}
	self flagsys::clear("in_vehicle");
	self.vehicle = undefined;
	self.rider_info = undefined;
	self animation::set_death_anim(undefined);
	set_goal();
	self notify(#"exited_vehicle");
}

/*
	Name: set_goal
	Namespace: vehicle
	Checksum: 0xBB29C691
	Offset: 0x1E28
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function set_goal()
{
	if(colors::is_color_ai())
	{
		colors::enable();
	}
	else if(!isdefined(self.target))
	{
		self setgoal(self.origin);
	}
}

/*
	Name: unload
	Namespace: vehicle
	Checksum: 0x26BF2D3C
	Offset: 0x1E90
	Size: 0x246
	Parameters: 4
	Flags: Linked
*/
function unload(str_group = "all", str_mode, remove_rider_before_unloading, remove_riders_wait_time)
{
	self notify(#"unload", str_group);
	/#
		assert(isdefined(level.vehiclerider_groups[str_group]), str_group + "");
	#/
	str_group = level.vehiclerider_groups[str_group];
	a_ai_unloaded = [];
	foreach(ai_rider in self.riders)
	{
		if(str_group == "all" || issubstr(ai_rider.rider_info.position, str_group))
		{
			ai_rider thread get_out(str_mode);
			if(!isdefined(a_ai_unloaded))
			{
				a_ai_unloaded = [];
			}
			else if(!isarray(a_ai_unloaded))
			{
				a_ai_unloaded = array(a_ai_unloaded);
			}
			a_ai_unloaded[a_ai_unloaded.size] = ai_rider;
		}
	}
	if(a_ai_unloaded.size > 0)
	{
		if(remove_rider_before_unloading === 1)
		{
			remove_riders_after_wait(remove_riders_wait_time, a_ai_unloaded);
		}
		array::flagsys_wait_clear(a_ai_unloaded, "in_vehicle", (isdefined(self.unloadtimeout) ? self.unloadtimeout : 4));
		self notify(#"unload", a_ai_unloaded);
	}
}

/*
	Name: remove_riders_after_wait
	Namespace: vehicle
	Checksum: 0xF122F610
	Offset: 0x20E0
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function remove_riders_after_wait(wait_time, a_riders_to_remove)
{
	wait(wait_time);
	if(isdefined(a_riders_to_remove))
	{
		foreach(ai in a_riders_to_remove)
		{
			arrayremovevalue(self.riders, ai);
		}
	}
}

/*
	Name: ragdoll_dead_exit_rider
	Namespace: vehicle
	Checksum: 0xD8670307
	Offset: 0x21A0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function ragdoll_dead_exit_rider()
{
	self endon(#"exited_vehicle");
	self waittill(#"death");
	if(isactor(self) && !self isragdoll())
	{
		self unlink();
		self startragdoll();
	}
}

/*
	Name: exit_ground
	Namespace: vehicle
	Checksum: 0xFA739E92
	Offset: 0x2228
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function exit_ground()
{
	self animation::set_death_anim(self.rider_info.exitgrounddeathanim);
	if(!isdefined(self.rider_info.exitgrounddeathanim))
	{
		self thread ragdoll_dead_exit_rider();
	}
	/#
		assert(isstring(self.rider_info.exitgroundanim), ("" + self.rider_info.position) + "");
	#/
	if(isstring(self.rider_info.exitgroundanim))
	{
		animation::play(self.rider_info.exitgroundanim, self.vehicle, self.rider_info.aligntag);
	}
}

/*
	Name: exit_low
	Namespace: vehicle
	Checksum: 0x843A5CD7
	Offset: 0x2338
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function exit_low()
{
	self animation::set_death_anim(self.rider_info.exitlowdeathanim);
	/#
		assert(isdefined(self.rider_info.exitlowanim), ("" + self.rider_info.position) + "");
	#/
	animation::play(self.rider_info.exitlowanim, self.vehicle, self.rider_info.aligntag);
}

/*
	Name: handle_falling_death
	Namespace: vehicle
	Checksum: 0x48433335
	Offset: 0x23F0
	Size: 0x64
	Parameters: 0
	Flags: Linked, Private
*/
function private handle_falling_death()
{
	self endon(#"landed");
	self waittill(#"death");
	if(isactor(self))
	{
		self unlink();
		self startragdoll();
	}
}

/*
	Name: forward_euler_integration
	Namespace: vehicle
	Checksum: 0x83C8381B
	Offset: 0x2460
	Size: 0x18E
	Parameters: 3
	Flags: Linked, Private
*/
function private forward_euler_integration(e_move, v_target_landing, n_initial_speed)
{
	landed = 0;
	integrationstep = 0.1;
	position = self.origin;
	velocity = (0, 0, n_initial_speed * -1);
	gravity = vectorscale((0, 0, -1), 385.8);
	while(!landed)
	{
		previousposition = position;
		velocity = velocity + (gravity * integrationstep);
		position = position + (velocity * integrationstep);
		if((position[2] + (velocity[2] * integrationstep)) <= v_target_landing[2])
		{
			landed = 1;
			position = v_target_landing;
		}
		/#
			recordline(previousposition, position, (1, 0.5, 0), "", self);
		#/
		hostmigration::waittillhostmigrationdone();
		e_move moveto(position, integrationstep);
		if(!landed)
		{
			wait(integrationstep);
		}
	}
}

/*
	Name: exit_variable
	Namespace: vehicle
	Checksum: 0xCD07A880
	Offset: 0x25F8
	Size: 0x48C
	Parameters: 0
	Flags: Linked
*/
function exit_variable()
{
	ai = self;
	self endon(#"death");
	self notify(#"exiting_vehicle");
	self thread handle_falling_death();
	self animation::set_death_anim(self.rider_info.exithighdeathanim);
	/#
		assert(isdefined(self.rider_info.exithighanim), ("" + self.rider_info.position) + "");
	#/
	animation::play(self.rider_info.exithighanim, self.vehicle, self.rider_info.aligntag, 1, 0, 0);
	self animation::set_death_anim(self.rider_info.exithighloopdeathanim);
	n_cur_height = get_height(self.vehicle);
	bundle = self.vehicle get_bundle_for_ai(ai);
	n_target_height = bundle.highexitlandheight;
	if(isdefined(self.rider_info.dropundervehicleorigin) && self.rider_info.dropundervehicleorigin || (isdefined(self.dropundervehicleoriginoverride) && self.dropundervehicleoriginoverride))
	{
		v_target_landing = (self.vehicle.origin[0], self.vehicle.origin[1], (self.origin[2] - n_cur_height) + n_target_height);
	}
	else
	{
		v_target_landing = (self.origin[0], self.origin[1], (self.origin[2] - n_cur_height) + n_target_height);
	}
	if(isdefined(self.overridedropposition))
	{
		v_target_landing = (self.overridedropposition[0], self.overridedropposition[1], v_target_landing[2]);
	}
	if(isdefined(self.targetangles))
	{
		angles = self.targetangles;
	}
	else
	{
		angles = self.angles;
	}
	e_move = util::spawn_model("tag_origin", self.origin, angles);
	self thread exit_high_loop_anim(e_move);
	distance = n_target_height - n_cur_height;
	initialspeed = bundle.dropspeed;
	acceleration = 385.8;
	n_fall_time = (initialspeed * -1) + (sqrt(pow(initialspeed, 2) - ((2 * acceleration) * distance))) / acceleration;
	self notify(#"falling", n_fall_time);
	forward_euler_integration(e_move, v_target_landing, bundle.dropspeed);
	e_move waittill(#"movedone");
	self notify(#"landing");
	self animation::set_death_anim(self.rider_info.exithighlanddeathanim);
	animation::play(self.rider_info.exithighlandanim, e_move, "tag_origin");
	self notify(#"landed");
	self unlink();
	wait(0.05);
	e_move delete();
}

/*
	Name: exit_high_loop_anim
	Namespace: vehicle
	Checksum: 0x57DD9DEE
	Offset: 0x2A90
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function exit_high_loop_anim(e_parent)
{
	self endon(#"death");
	self endon(#"landing");
	while(true)
	{
		animation::play(self.rider_info.exithighloopanim, e_parent, "tag_origin");
	}
}

/*
	Name: get_height
	Namespace: vehicle
	Checksum: 0xA63570E0
	Offset: 0x2AF0
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function get_height(e_ignore = self)
{
	trace = groundtrace(self.origin + (0, 0, 10), self.origin + (vectorscale((0, 0, -1), 10000)), 0, e_ignore, 0);
	/#
		recordline(self.origin + (0, 0, 10), trace[""], (1, 0.5, 0), "", self);
	#/
	return distance(self.origin, trace["position"]);
}

/*
	Name: get_bundle
	Namespace: vehicle
	Checksum: 0xD1DC17F2
	Offset: 0x2BE8
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function get_bundle()
{
	/#
		assert(isdefined(self.vehicleridersbundle), "");
	#/
	return struct::get_script_bundle("vehicleriders", self.vehicleridersbundle);
}

/*
	Name: get_robot_bundle
	Namespace: vehicle
	Checksum: 0xB237F061
	Offset: 0x2C40
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function get_robot_bundle()
{
	/#
		assert(isdefined(self.vehicleridersrobotbundle), "");
	#/
	return struct::get_script_bundle("vehicleriders", self.vehicleridersrobotbundle);
}

/*
	Name: get_rider
	Namespace: vehicle
	Checksum: 0x6CEE42B7
	Offset: 0x2C98
	Size: 0xB8
	Parameters: 1
	Flags: None
*/
function get_rider(str_pos)
{
	if(isdefined(self.riders))
	{
		foreach(ai in self.riders)
		{
			if(isdefined(ai) && ai.rider_info.position == str_pos)
			{
				return ai;
			}
		}
	}
}

/*
	Name: _init_rider
	Namespace: vehicle
	Checksum: 0xBB12BCB5
	Offset: 0x2D58
	Size: 0xD4
	Parameters: 2
	Flags: Linked, Private
*/
function private _init_rider(vh, str_pos)
{
	/#
		assert(isdefined(self.vehicle) || isdefined(vh), "");
	#/
	/#
		assert(isdefined(self.rider_info) || isdefined(str_pos), "");
	#/
	if(isdefined(vh))
	{
		self.vehicle = vh;
	}
	if(!isdefined(str_pos))
	{
		str_pos = self.rider_info.position;
	}
	self.rider_info = self get_rider_info(self.vehicle, str_pos);
}

