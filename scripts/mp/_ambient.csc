// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;

#namespace ambient;

/*
	Name: __init__sytem__
	Namespace: ambient
	Checksum: 0xA0C5D201
	Offset: 0x3E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ambient", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ambient
	Checksum: 0x2BE0287E
	Offset: 0x420
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localclient_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: ambient
	Checksum: 0xDA61513
	Offset: 0x450
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function on_player_connect(localclientnum)
{
	thread ceiling_fans_init(localclientnum);
	thread clocks_init(localclientnum);
	thread spin_anemometers(localclientnum);
	if(isdefined(level._levelspecificambient))
	{
		thread [[level._levelspecificambient]](localclientnum);
	}
}

/*
	Name: setup_point_fx
	Namespace: ambient
	Checksum: 0xBE42AC42
	Offset: 0x4D0
	Size: 0x164
	Parameters: 2
	Flags: None
*/
function setup_point_fx(point, fx_id)
{
	if(isdefined(point.script_fxid))
	{
		fx_id = point.script_fxid;
	}
	point.fx_id = fx_id;
	if(isdefined(point.angles))
	{
		point.forward = anglestoforward(point.angles);
		point.up = anglestoup(point.angles);
	}
	else
	{
		point.angles = (0, 0, 0);
		point.forward = (0, 0, 0);
		point.up = (0, 0, 0);
	}
	if(point.targetname == "flak_fire_fx")
	{
		level thread ambient_flak_think(point);
	}
	if(point.targetname == "fake_fire_fx")
	{
		level thread ambient_fakefire_think(point);
	}
}

/*
	Name: ambient_flak_think
	Namespace: ambient
	Checksum: 0xA87A8E6
	Offset: 0x640
	Size: 0x1D8
	Parameters: 1
	Flags: Linked
*/
function ambient_flak_think(point)
{
	amount = undefined;
	speed = undefined;
	night = 0;
	min_delay = 0.4;
	max_delay = 4;
	min_burst_time = 1;
	max_burst_time = 3;
	point.is_firing = 0;
	level thread ambient_flak_rotate(point);
	level thread ambient_flak_flash(point, min_burst_time, max_burst_time);
	for(;;)
	{
		timer = randomfloatrange(min_burst_time, max_burst_time);
		while(timer > 0)
		{
			point.is_firing = 1;
			playfx(0, level._effect[point.fx_id], point.origin, point.forward, point.up);
			thread sound::play_in_space(0, "wpn_triple25_fire", point.origin);
			wait(0.2);
			timer = timer - 0.2;
		}
		point.is_firing = 0;
		wait(randomfloatrange(min_delay, max_delay));
	}
}

/*
	Name: ambient_flak_rotate
	Namespace: ambient
	Checksum: 0x21921C11
	Offset: 0x820
	Size: 0x228
	Parameters: 1
	Flags: Linked
*/
function ambient_flak_rotate(point)
{
	min_pitch = 30;
	max_pitch = 80;
	if(isdefined(point.angles))
	{
		pointangles = point.angles;
	}
	else
	{
		pointangles = (0, 0, 0);
	}
	for(;;)
	{
		time = randomfloatrange(0.5, 2);
		steps = time * 10;
		random_angle = (randomintrange(min_pitch, max_pitch) * -1, randomint(360), 0);
		forward = anglestoforward(random_angle);
		up = anglestoup(random_angle);
		diff_forward = (forward - point.forward) / steps;
		diff_up = (up - point.up) / steps;
		for(i = 0; i < steps; i++)
		{
			point.forward = point.forward + diff_forward;
			point.up = point.up + diff_up;
			wait(0.1);
		}
		point.forward = forward;
		point.up = up;
	}
}

/*
	Name: ambient_flak_flash
	Namespace: ambient
	Checksum: 0x915CB75C
	Offset: 0xA50
	Size: 0x1C0
	Parameters: 3
	Flags: Linked
*/
function ambient_flak_flash(point, min_burst_time, max_burst_time)
{
	min_dist = 5000;
	max_dist = 6500;
	if(isdefined(point.script_mindist))
	{
		min_dist = point.script_mindist;
	}
	if(isdefined(point.script_maxdist))
	{
		max_dist = point.script_maxdist;
	}
	min_burst_time = 0.25;
	max_burst_time = 1;
	fxpos = undefined;
	while(true)
	{
		if(!point.is_firing)
		{
			wait(0.25);
			continue;
		}
		fxpos = point.origin + vectorscale(point.forward, randomintrange(min_dist, max_dist));
		playfx(0, level._effect["flak_burst_single"], fxpos);
		if(isdefined(level.timeofday) && (level.timeofday == "evening" || level.timeofday == "night"))
		{
			playfx(0, level._effect["flak_cloudflash_night"], fxpos);
		}
		wait(randomfloatrange(min_burst_time, max_burst_time));
	}
}

/*
	Name: ambient_fakefire_think
	Namespace: ambient
	Checksum: 0xCB84B40D
	Offset: 0xC18
	Size: 0x7C0
	Parameters: 1
	Flags: Linked
*/
function ambient_fakefire_think(point)
{
	firesound = undefined;
	weaptype = undefined;
	burstmin = undefined;
	burstmax = undefined;
	betweenshotsmin = undefined;
	betweenshotsmax = undefined;
	reloadtimemin = undefined;
	reloadtimemax = undefined;
	soundchance = undefined;
	if(!isdefined(point.weaponinfo))
	{
		point.weaponinfo = "axis_turret";
	}
	switch(point.weaponinfo)
	{
		case "allies_assault":
		{
			if(isdefined(level.allies_team) && level.allies_team == "marines")
			{
				firesound = "weap_bar_fire";
			}
			else
			{
				firesound = "weap_dp28_fire_plr";
			}
			burstmin = 16;
			burstmax = 24;
			betweenshotsmin = 0.05;
			betweenshotsmax = 0.08;
			reloadtimemin = 4;
			reloadtimemax = 7;
			soundchance = 75;
			weaptype = "assault";
			break;
		}
		case "axis_assault":
		{
			if(isdefined(level.axis_team) && level.axis_team == "german")
			{
				firesound = "weap_mp44_fire";
			}
			else
			{
				firesound = "weap_type99_fire";
			}
			burstmin = 16;
			burstmax = 24;
			betweenshotsmin = 0.05;
			betweenshotsmax = 0.08;
			reloadtimemin = 4;
			reloadtimemax = 7;
			soundchance = 75;
			weaptype = "assault";
			break;
		}
		case "allies_rifle":
		{
			if(isdefined(level.allies_team) && level.allies_team == "marines")
			{
				firesound = "weap_m1garand_fire";
			}
			else
			{
				firesound = "weap_mosinnagant_fire";
			}
			burstmin = 1;
			burstmax = 3;
			betweenshotsmin = 0.8;
			betweenshotsmax = 1.3;
			reloadtimemin = 3;
			reloadtimemax = 6;
			soundchance = 95;
			weaptype = "rifle";
			break;
		}
		case "axis_rifle":
		{
			if(isdefined(level.axis_team) && level.axis_team == "german")
			{
				firesound = "weap_kar98k_fire";
			}
			else
			{
				firesound = "weap_arisaka_fire";
			}
			burstmin = 1;
			burstmax = 3;
			betweenshotsmin = 0.8;
			betweenshotsmax = 1.3;
			reloadtimemin = 3;
			reloadtimemax = 6;
			soundchance = 95;
			weaptype = "rifle";
			break;
		}
		case "allies_smg":
		{
			if(isdefined(level.allies_team) && level.allies_team == "marines")
			{
				firesound = "weap_thompson_fire";
			}
			else
			{
				firesound = "weap_ppsh_fire";
			}
			burstmin = 14;
			burstmax = 28;
			betweenshotsmin = 0.08;
			betweenshotsmax = 0.12;
			reloadtimemin = 2;
			reloadtimemax = 5;
			soundchance = 75;
			weaptype = "smg";
			break;
		}
		case "axis_smg":
		{
			if(isdefined(level.axis_team) && level.axis_team == "german")
			{
				firesound = "weap_mp40_fire";
			}
			else
			{
				firesound = "weap_type100_fire";
			}
			burstmin = 14;
			burstmax = 28;
			betweenshotsmin = 0.08;
			betweenshotsmax = 0.12;
			reloadtimemin = 2;
			reloadtimemax = 5;
			soundchance = 75;
			weaptype = "smg";
			break;
		}
		case "allies_turret":
		{
			if(isdefined(level.allies_team) && level.allies_team == "marines")
			{
				firesound = "weap_30cal_fire";
			}
			else
			{
				firesound = "weap_dp28_fire_plr";
			}
			burstmin = 60;
			burstmax = 90;
			betweenshotsmin = 0.05;
			betweenshotsmax = 0.08;
			reloadtimemin = 3;
			reloadtimemax = 6;
			soundchance = 95;
			weaptype = "turret";
			break;
		}
		case "axis_turret":
		{
			if(isdefined(level.axis_team) && level.axis_team == "german")
			{
				firesound = "weap_bar_fire";
			}
			else
			{
				firesound = "weap_type92_fire";
			}
			burstmin = 60;
			burstmax = 90;
			betweenshotsmin = 0.05;
			betweenshotsmax = 0.08;
			reloadtimemin = 3;
			reloadtimemax = 6;
			soundchance = 95;
			weaptype = "turret";
			break;
		}
		default:
		{
			/#
				assertmsg(("" + point.weaponinfo) + "");
			#/
		}
	}
	while(true)
	{
		burst = randomintrange(burstmin, burstmax);
		for(i = 0; i < burst; i++)
		{
			tracedist = 10000;
			target = point.origin + (vectorscale(anglestoforward(point.angles + (-3 + randomint(6), -5 + randomint(10), 0)), tracedist));
			if(randomint(100) <= 20)
			{
				bullettracer(point.origin, target);
			}
			playfx(0, level._effect[point.fx_id], point.origin, point.forward);
			wait(randomfloatrange(betweenshotsmin, betweenshotsmax));
		}
		wait(randomfloatrange(reloadtimemin, reloadtimemax));
	}
}

/*
	Name: ceiling_fans_init
	Namespace: ambient
	Checksum: 0xF777BC7F
	Offset: 0x13E0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function ceiling_fans_init(clientnum)
{
	fan_array = getentarray(clientnum, "ceiling_fan", "targetname");
	if(isdefined(fan_array))
	{
		/#
			println("" + fan_array.size);
		#/
		array::thread_all(fan_array, &spin_fan);
	}
}

/*
	Name: spin_fan
	Namespace: ambient
	Checksum: 0xF94142B4
	Offset: 0x1478
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function spin_fan()
{
	self endon(#"entityshutdown");
	if(!isdefined(self.speed))
	{
		self.speed = randomintrange(1, 100);
		self.speed = (self.speed % 10) + 1;
	}
	if(self.speed < 1)
	{
		self.speed = randomintrange(1, 100);
		self.speed = (self.speed % 10) + 1;
	}
	do_wobble = 0;
	wobble = self.script_noteworthy;
	if(isdefined(wobble))
	{
		if(wobble == "wobble")
		{
			do_wobble = 1;
			self.wobble_speed = self.speed * 0.5;
		}
	}
	while(true)
	{
		if(!do_wobble)
		{
			self rotateyaw(180, self.speed);
			self waittill(#"rotatedone");
		}
		else
		{
			self rotateyaw(340, self.speed);
			self waittill(#"rotatedone");
			self rotateyaw(20, self.wobble_speed);
			self waittill(#"rotatedone");
		}
	}
}

/*
	Name: clocks_init
	Namespace: ambient
	Checksum: 0x5F99965F
	Offset: 0x1630
	Size: 0x3FC
	Parameters: 1
	Flags: Linked
*/
function clocks_init(clientnum)
{
	curr_time = getsystemtime();
	hours = curr_time[0];
	if(hours > 12)
	{
		hours = hours - 12;
	}
	if(hours == 0)
	{
		hours = 12;
	}
	minutes = curr_time[1];
	seconds = curr_time[2];
	hour_hand = getentarray(clientnum, "hour_hand", "targetname");
	hour_values = [];
	hour_values["hand_time"] = hours;
	hour_values["rotate"] = 30;
	hour_values["rotate_bit"] = 0.008333334;
	hour_values["first_rotate"] = ((minutes * 60) + seconds) * hour_values["rotate_bit"];
	minute_hand = getentarray(clientnum, "minute_hand", "targetname");
	minute_values = [];
	minute_values["hand_time"] = minutes;
	minute_values["rotate"] = 6;
	minute_values["rotate_bit"] = 0.1;
	minute_values["first_rotate"] = seconds * minute_values["rotate_bit"];
	second_hand = getentarray(clientnum, "second_hand", "targetname");
	second_values = [];
	second_values["hand_time"] = seconds;
	second_values["rotate"] = 6;
	second_values["rotate_bit"] = 6;
	hour_hand_array = getentarray(clientnum, "hour_hand", "targetname");
	if(isdefined(hour_hand_array))
	{
		/#
			println("" + hour_hand_array.size);
		#/
		array::thread_all(hour_hand_array, &clock_run, hour_values);
	}
	minute_hand_array = getentarray(clientnum, "minute_hand", "targetname");
	if(isdefined(minute_hand_array))
	{
		/#
			println("" + minute_hand_array.size);
		#/
		array::thread_all(minute_hand_array, &clock_run, minute_values);
	}
	second_hand_array = getentarray(clientnum, "second_hand", "targetname");
	if(isdefined(second_hand_array))
	{
		/#
			println("" + second_hand_array.size);
		#/
		array::thread_all(second_hand_array, &clock_run, second_values);
	}
}

/*
	Name: clock_run
	Namespace: ambient
	Checksum: 0xDA8A5A03
	Offset: 0x1A38
	Size: 0x3AC
	Parameters: 1
	Flags: Linked
*/
function clock_run(time_values)
{
	self endon(#"entityshutdown");
	if(isdefined(self.script_noteworthy))
	{
		hour = time_values["hand_time"];
		curr_time = getsystemtime(1);
		switch(tolower(self.script_noteworthy))
		{
			case "honolulu":
			{
				hour = curr_time[0] - 10;
				break;
			}
			case "alaska":
			{
				hour = curr_time[0] - 9;
				break;
			}
			case "los angeles":
			{
				hour = curr_time[0] - 8;
				break;
			}
			case "denver":
			{
				hour = curr_time[0] - 7;
				break;
			}
			case "chicago":
			{
				hour = curr_time[0] - 6;
				break;
			}
			case "new york":
			{
				hour = curr_time[0] - 5;
				break;
			}
			case "halifax":
			{
				hour = curr_time[0] - 4;
				break;
			}
			case "greenland":
			{
				hour = curr_time[0] - 3;
				break;
			}
			case "london":
			{
				hour = curr_time[0];
				break;
			}
			case "paris":
			{
				hour = curr_time[0] + 1;
				break;
			}
			case "helsinki":
			{
				hour = curr_time[0] + 2;
				break;
			}
			case "moscow":
			{
				hour = curr_time[0] + 3;
				break;
			}
			case "vietnam":
			{
				hour = curr_time[0] + 7;
				break;
			}
			case "china":
			{
				hour = curr_time[0] + 8;
				break;
			}
		}
		if(hour < 1)
		{
			hour = hour + 12;
		}
		if(hour > 12)
		{
			hour = hour - 12;
		}
		time_values["hand_time"] = hour;
	}
	self rotatepitch(time_values["hand_time"] * time_values["rotate"], 0.05);
	self waittill(#"rotatedone");
	if(isdefined(time_values["first_rotate"]))
	{
		self rotatepitch(time_values["first_rotate"], 0.05);
		self waittill(#"rotatedone");
	}
	prev_time = getsystemtime();
	while(true)
	{
		curr_time = getsystemtime();
		if(prev_time != curr_time)
		{
			self rotatepitch(time_values["rotate_bit"], 0.05);
			prev_time = curr_time;
		}
		wait(1);
	}
}

/*
	Name: spin_anemometers
	Namespace: ambient
	Checksum: 0xC01C641D
	Offset: 0x1DF0
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function spin_anemometers(clientnum)
{
	spoon_spinners = getentarray(clientnum, "spinner1", "targetname");
	flat_spinners = getentarray(clientnum, "spinner2", "targetname");
	if(isdefined(spoon_spinners))
	{
		/#
			println("" + spoon_spinners.size);
		#/
		array::thread_all(spoon_spinners, &spoon_spin_func);
	}
	if(isdefined(flat_spinners))
	{
		/#
			println("" + flat_spinners.size);
		#/
		array::thread_all(flat_spinners, &arrow_spin_func);
	}
}

/*
	Name: spoon_spin_func
	Namespace: ambient
	Checksum: 0xB5684BDE
	Offset: 0x1F08
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function spoon_spin_func()
{
	self endon(#"entityshutdown");
	if(isdefined(self.script_float))
	{
		model_speed = self.script_float;
	}
	else
	{
		model_speed = 2;
	}
	while(true)
	{
		speed = randomfloatrange(model_speed * 0.6, model_speed);
		self rotateyaw(1200, speed);
		self waittill(#"rotatedone");
	}
}

/*
	Name: arrow_spin_func
	Namespace: ambient
	Checksum: 0x841511E3
	Offset: 0x1FB8
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function arrow_spin_func()
{
	self endon(#"entityshutdown");
	if(isdefined(self.script_int))
	{
		model_direction_change = self.script_int;
	}
	else
	{
		model_direction_change = 25;
	}
	if(isdefined(self.script_float))
	{
		model_speed = self.script_float;
	}
	else
	{
		model_speed = 0.8;
	}
	while(true)
	{
		direction_change = model_direction_change + (randomintrange(-11, 11));
		speed_change = randomfloatrange(model_speed * 0.3, model_speed);
		self rotateyaw(direction_change, speed_change);
		self waittill(#"rotatedone");
		self rotateyaw(direction_change * -1, speed_change);
		self waittill(#"rotatedone");
	}
}

