// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\audio_shared;

class groundfx 
{
	var handle;
	var id;

	/*
		Name: constructor
		Namespace: groundfx
		Checksum: 0xA01B94AE
		Offset: 0x230
		Size: 0x1C
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		id = undefined;
		handle = -1;
	}

	/*
		Name: destructor
		Namespace: groundfx
		Checksum: 0x99EC1590
		Offset: 0x258
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: stop
		Namespace: groundfx
		Checksum: 0xC63CA503
		Offset: 0x3B8
		Size: 0x4C
		Parameters: 1
		Flags: Linked
	*/
	function stop(localclientnum)
	{
		if(handle > 0)
		{
			stopfx(localclientnum, handle);
		}
		id = undefined;
		handle = -1;
	}

	/*
		Name: play
		Namespace: groundfx
		Checksum: 0x905DFBEF
		Offset: 0x268
		Size: 0x144
		Parameters: 4
		Flags: Linked
	*/
	function play(localclientnum, vehicle, fx_id, fx_tag)
	{
		if(!isdefined(fx_id))
		{
			if(handle > 0)
			{
				stopfx(localclientnum, handle);
			}
			id = undefined;
			handle = -1;
			return;
		}
		if(!isdefined(id))
		{
			id = fx_id;
			handle = playfxontag(localclientnum, id, vehicle, fx_tag);
		}
		else if(!isdefined(id) || id != fx_id)
		{
			if(handle > 0)
			{
				stopfx(localclientnum, handle);
			}
			id = fx_id;
			handle = playfxontag(localclientnum, id, vehicle, fx_tag);
		}
	}

}

class vehiclewheelfx 
{
	var ground_fx;
	var name;
	var tag_name;

	/*
		Name: constructor
		Namespace: vehiclewheelfx
		Checksum: 0xF9540FA9
		Offset: 0x500
		Size: 0x24
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		name = "";
		tag_name = "";
	}

	/*
		Name: destructor
		Namespace: vehiclewheelfx
		Checksum: 0x99EC1590
		Offset: 0x530
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: update
		Namespace: vehiclewheelfx
		Checksum: 0x643322EF
		Offset: 0x610
		Size: 0x4CC
		Parameters: 3
		Flags: Linked
	*/
	function update(localclientnum, vehicle, speed_fraction)
	{
		if(vehicle.vehicleclass === "boat")
		{
			peelingout = 0;
			sliding = 0;
			trace = bullettrace(vehicle.origin + vectorscale((0, 0, 1), 60), vehicle.origin - vectorscale((0, 0, 1), 200), 0, vehicle);
			if(trace["fraction"] < 1)
			{
				surface = trace["surfacetype"];
			}
			else
			{
				[[ ground_fx["skid"] ]]->stop(localclientnum);
				[[ ground_fx["tread"] ]]->stop(localclientnum);
				return;
			}
		}
		else
		{
			if(!vehicle iswheelcolliding(name))
			{
				[[ ground_fx["skid"] ]]->stop(localclientnum);
				[[ ground_fx["tread"] ]]->stop(localclientnum);
				return;
			}
			peelingout = vehicle iswheelpeelingout(name);
			sliding = vehicle iswheelsliding(name);
			surface = vehicle getwheelsurface(name);
		}
		origin = vehicle gettagorigin(tag_name) + (0, 0, 1);
		angles = vehicle gettagangles(tag_name);
		fwd = anglestoforward(angles);
		right = anglestoright(angles);
		rumble = 0;
		if(peelingout)
		{
			peel_fx = vehicle driving_fx::get_wheel_fx("peel", surface);
			if(isdefined(peel_fx))
			{
				playfx(localclientnum, peel_fx, origin, fwd * -1);
				rumble = 1;
			}
		}
		if(sliding)
		{
			skid_fx = vehicle driving_fx::get_wheel_fx("skid", surface);
			[[ ground_fx["skid"] ]]->play(localclientnum, vehicle, skid_fx, tag_name);
			vehicle.skidding = 1;
			rumble = 1;
		}
		else
		{
			[[ ground_fx["skid"] ]]->stop(localclientnum);
		}
		if(speed_fraction > 0.1)
		{
			tread_fx = vehicle driving_fx::get_wheel_fx("tread", surface);
			[[ ground_fx["tread"] ]]->play(localclientnum, vehicle, tread_fx, tag_name);
		}
		else
		{
			[[ ground_fx["tread"] ]]->stop(localclientnum);
		}
		if(rumble)
		{
			if(vehicle islocalclientdriver(localclientnum))
			{
				player = getlocalplayer(localclientnum);
				player playrumbleonentity(localclientnum, "reload_small");
			}
		}
	}

	/*
		Name: init
		Namespace: vehiclewheelfx
		Checksum: 0x90CD92F7
		Offset: 0x540
		Size: 0xC4
		Parameters: 2
		Flags: Linked
	*/
	function init(_name, _tag_name)
	{
		name = _name;
		tag_name = _tag_name;
		ground_fx = [];
		ground_fx["skid"] = new groundfx();
		ground_fx["tread"] = new groundfx();
		ground_fx["tread"].id = "";
		ground_fx["tread"].handle = -1;
	}

}

class vehicle_camera_fx 
{
	var quake_strength_max;
	var quake_strength_min;
	var quake_time_max;
	var quake_time_min;
	var rumble_name;

	/*
		Name: constructor
		Namespace: vehicle_camera_fx
		Checksum: 0xFC47A4E4
		Offset: 0xBD8
		Size: 0x54
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		quake_time_min = 0.5;
		quake_time_max = 1;
		quake_strength_min = 0.1;
		quake_strength_max = 0.115;
		rumble_name = "";
	}

	/*
		Name: destructor
		Namespace: vehicle_camera_fx
		Checksum: 0x99EC1590
		Offset: 0xC38
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: update
		Namespace: vehicle_camera_fx
		Checksum: 0x4DA12EC7
		Offset: 0xCF0
		Size: 0x14C
		Parameters: 3
		Flags: Linked
	*/
	function update(localclientnum, vehicle, speed_fraction)
	{
		if(vehicle islocalclientdriver(localclientnum))
		{
			player = getlocalplayer(localclientnum);
			if(speed_fraction > 0)
			{
				strength = randomfloatrange(quake_strength_min, quake_strength_max) * speed_fraction;
				time = randomfloatrange(quake_time_min, quake_time_max);
				player earthquake(strength, time, player.origin, 500);
				if(rumble_name != "" && speed_fraction > 0.5)
				{
					if(randomint(100) < 10)
					{
						player playrumbleonentity(localclientnum, rumble_name);
					}
				}
			}
		}
	}

	/*
		Name: init
		Namespace: vehicle_camera_fx
		Checksum: 0xC5554CEC
		Offset: 0xC48
		Size: 0x9C
		Parameters: 5
		Flags: Linked
	*/
	function init(t_min, t_max, s_min, s_max, rumble = "")
	{
		quake_time_min = t_min;
		quake_time_max = t_max;
		quake_strength_min = s_min;
		quake_strength_max = s_max;
		rumble_name = (rumble != "" ? rumble : rumble_name);
	}

}

#namespace driving_fx;

/*
	Name: vehicle_enter
	Namespace: driving_fx
	Checksum: 0xC478FBF5
	Offset: 0xF38
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function vehicle_enter(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"enter_vehicle", user);
		if(isdefined(user) && user isplayer())
		{
			self thread collision_thread(localclientnum);
			self thread jump_landing_thread(localclientnum);
		}
	}
}

/*
	Name: speed_fx
	Namespace: driving_fx
	Checksum: 0xF1B6C61A
	Offset: 0xFD0
	Size: 0x100
	Parameters: 1
	Flags: None
*/
function speed_fx(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"exit_vehicle");
	while(true)
	{
		curspeed = self getspeed();
		curspeed = 0.0005 * curspeed;
		curspeed = abs(curspeed);
		if(curspeed > 0.001)
		{
			setsaveddvar("r_speedBlurFX_enable", "1");
			setsaveddvar("r_speedBlurAmount", curspeed);
		}
		else
		{
			setsaveddvar("r_speedBlurFX_enable", "0");
		}
		wait(0.05);
	}
}

/*
	Name: play_driving_fx
	Namespace: driving_fx
	Checksum: 0x5089F7A7
	Offset: 0x10D8
	Size: 0x420
	Parameters: 1
	Flags: Linked
*/
function play_driving_fx(localclientnum)
{
	self endon(#"entityshutdown");
	self thread vehicle_enter(localclientnum);
	if(self.surfacefxdeftype == "")
	{
		return;
	}
	if(!isdefined(self.wheel_fx))
	{
		wheel_names = array("front_left", "front_right", "back_left", "back_right");
		wheel_tag_names = array("tag_wheel_front_left", "tag_wheel_front_right", "tag_wheel_back_left", "tag_wheel_back_right");
		if(isdefined(self.scriptvehicletype) && self.scriptvehicletype == "raps")
		{
			wheel_names = array("front_left");
			wheel_tag_names = array("tag_origin");
		}
		else if(self.vehicleclass == "boat")
		{
			wheel_names = array("tag_origin");
			wheel_tag_names = array("tag_origin");
		}
		self.wheel_fx = [];
		for(i = 0; i < wheel_names.size; i++)
		{
			self.wheel_fx[i] = new vehiclewheelfx();
			[[ self.wheel_fx[i] ]]->init(wheel_names[i], wheel_tag_names[i]);
		}
		self.camera_fx = [];
		self.camera_fx["speed"] = new vehicle_camera_fx();
		[[ self.camera_fx["speed"] ]]->init(0.5, 1, 0.1, 0.115, "reload_small");
		self.camera_fx["skid"] = new vehicle_camera_fx();
		[[ self.camera_fx["skid"] ]]->init(0.25, 0.35, 0.1, 0.115);
	}
	self.last_screen_dirt = 0;
	self.screen_dirt_delay = 0;
	speed_fraction = 0;
	while(true)
	{
		speed = length(self getvelocity());
		max_speed = (speed < 0 ? self getmaxreversespeed() : self getmaxspeed());
		speed_fraction = (max_speed > 0 ? abs(speed) / max_speed : 0);
		self.skidding = 0;
		for(i = 0; i < self.wheel_fx.size; i++)
		{
			[[ self.wheel_fx[i] ]]->update(localclientnum, self, speed_fraction);
		}
		wait(0.1);
	}
}

/*
	Name: get_wheel_fx
	Namespace: driving_fx
	Checksum: 0x2887D680
	Offset: 0x1500
	Size: 0x98
	Parameters: 2
	Flags: Linked
*/
function get_wheel_fx(type, surface)
{
	fxarray = undefined;
	if(type == "tread")
	{
		fxarray = self.treadfxnamearray;
	}
	else
	{
		if(type == "peel")
		{
			fxarray = self.peelfxnamearray;
		}
		else if(type == "skid")
		{
			fxarray = self.skidfxnamearray;
		}
	}
	if(isdefined(fxarray))
	{
		return fxarray[surface];
	}
	return undefined;
}

/*
	Name: play_driving_fx_firstperson
	Namespace: driving_fx
	Checksum: 0x9ED9B95B
	Offset: 0x15A0
	Size: 0x1BC
	Parameters: 3
	Flags: None
*/
function play_driving_fx_firstperson(localclientnum, speed, speed_fraction)
{
	if(speed > 0 && speed_fraction >= 0.25)
	{
		viewangles = getlocalclientangles(localclientnum);
		pitch = angleclamp180(viewangles[0]);
		if(pitch > -10)
		{
			current_additional_time = 0;
			if(pitch < 10)
			{
				current_additional_time = 1000 * ((pitch - 10) / -10 - 10);
			}
			if(((self.last_screen_dirt + self.screen_dirt_delay) + current_additional_time) < getrealtime())
			{
				screen_fx_type = self correct_surface_type_for_screen_fx();
				if(screen_fx_type == "dirt")
				{
					play_screen_fx_dirt(localclientnum);
				}
				else
				{
					play_screen_fx_dust(localclientnum);
				}
				self.last_screen_dirt = getrealtime();
				self.screen_dirt_delay = randomintrange(250, 500);
			}
		}
	}
}

/*
	Name: collision_thread
	Namespace: driving_fx
	Checksum: 0x589A0041
	Offset: 0x1768
	Size: 0x268
	Parameters: 1
	Flags: Linked
*/
function collision_thread(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"exit_vehicle");
	while(true)
	{
		self waittill(#"veh_collision", hip, hitn, hit_intensity);
		if(self islocalclientdriver(localclientnum))
		{
			player = getlocalplayer(localclientnum);
			if(isdefined(self.driving_fx_collision_override))
			{
				self [[self.driving_fx_collision_override]](localclientnum, player, hip, hitn, hit_intensity);
			}
			else if(isdefined(player) && isdefined(hit_intensity))
			{
				if(hit_intensity > self.heavycollisionspeed)
				{
					volume = get_impact_vol_from_speed();
					if(isdefined(self.sounddef))
					{
						alias = self.sounddef + "_suspension_lg_hd";
					}
					else
					{
						alias = "veh_default_suspension_lg_hd";
					}
					id = playsound(0, alias, self.origin, volume);
					if(isdefined(self.heavycollisionrumble))
					{
						player playrumbleonentity(localclientnum, self.heavycollisionrumble);
					}
				}
				else if(hit_intensity > self.lightcollisionspeed)
				{
					volume = get_impact_vol_from_speed();
					if(isdefined(self.sounddef))
					{
						alias = self.sounddef + "_suspension_lg_lt";
					}
					else
					{
						alias = "veh_default_suspension_lg_lt";
					}
					id = playsound(0, alias, self.origin, volume);
					if(isdefined(self.lightcollisionrumble))
					{
						player playrumbleonentity(localclientnum, self.lightcollisionrumble);
					}
				}
			}
		}
	}
}

/*
	Name: jump_landing_thread
	Namespace: driving_fx
	Checksum: 0xEBD6AE0A
	Offset: 0x19D8
	Size: 0x168
	Parameters: 1
	Flags: Linked
*/
function jump_landing_thread(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"exit_vehicle");
	while(true)
	{
		self waittill(#"veh_landed");
		if(self islocalclientdriver(localclientnum))
		{
			player = getlocalplayer(localclientnum);
			if(isdefined(player))
			{
				if(isdefined(self.driving_fx_jump_landing_override))
				{
					self [[self.driving_fx_jump_landing_override]](localclientnum, player);
				}
				else
				{
					volume = get_impact_vol_from_speed();
					if(isdefined(self.sounddef))
					{
						alias = self.sounddef + "_suspension_lg_hd";
					}
					else
					{
						alias = "veh_default_suspension_lg_hd";
					}
					id = playsound(0, alias, self.origin, volume);
					if(isdefined(self.jumplandingrumble))
					{
						player playrumbleonentity(localclientnum, self.jumplandingrumble);
					}
				}
			}
		}
	}
}

/*
	Name: suspension_thread
	Namespace: driving_fx
	Checksum: 0xA0CEDF44
	Offset: 0x1B48
	Size: 0x138
	Parameters: 1
	Flags: None
*/
function suspension_thread(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"exit_vehicle");
	while(true)
	{
		self waittill(#"veh_suspension_limit_activated");
		if(self islocalclientdriver(localclientnum))
		{
			player = getlocalplayer(localclientnum);
			if(isdefined(player))
			{
				volume = get_impact_vol_from_speed();
				if(isdefined(self.sounddef))
				{
					alias = self.sounddef + "_suspension_lg_lt";
				}
				else
				{
					alias = "veh_default_suspension_lg_lt";
				}
				id = playsound(0, alias, self.origin, volume);
				player playrumbleonentity(localclientnum, "damage_light");
			}
		}
	}
}

/*
	Name: get_impact_vol_from_speed
	Namespace: driving_fx
	Checksum: 0xF01DBE94
	Offset: 0x1C88
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function get_impact_vol_from_speed()
{
	curspeed = self getspeed();
	maxspeed = self getmaxspeed();
	volume = audio::scale_speed(0, maxspeed, 0, 1, curspeed);
	volume = (volume * volume) * volume;
	return volume;
}

/*
	Name: any_wheel_colliding
	Namespace: driving_fx
	Checksum: 0x7586DCC2
	Offset: 0x1D28
	Size: 0x82
	Parameters: 0
	Flags: None
*/
function any_wheel_colliding()
{
	return self iswheelcolliding("front_left") || self iswheelcolliding("front_right") || self iswheelcolliding("back_left") || self iswheelcolliding("back_right");
}

/*
	Name: dirt_surface_type
	Namespace: driving_fx
	Checksum: 0x3828985E
	Offset: 0x1DB8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function dirt_surface_type(surface_type)
{
	switch(surface_type)
	{
		case "dirt":
		case "foliage":
		case "grass":
		case "gravel":
		case "mud":
		case "sand":
		case "snow":
		case "water":
		{
			return true;
		}
	}
	return false;
}

/*
	Name: correct_surface_type_for_screen_fx
	Namespace: driving_fx
	Checksum: 0x83E32467
	Offset: 0x1E28
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function correct_surface_type_for_screen_fx()
{
	right_rear = self getwheelsurface("back_right");
	left_rear = self getwheelsurface("back_left");
	if(dirt_surface_type(right_rear))
	{
		return "dirt";
	}
	if(dirt_surface_type(left_rear))
	{
		return "dirt";
	}
	return "dust";
}

/*
	Name: play_screen_fx_dirt
	Namespace: driving_fx
	Checksum: 0xC2E449D9
	Offset: 0x1ED0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function play_screen_fx_dirt(localclientnum)
{
}

/*
	Name: play_screen_fx_dust
	Namespace: driving_fx
	Checksum: 0x6D06D3AA
	Offset: 0x1EE8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function play_screen_fx_dust(localclientnum)
{
}

