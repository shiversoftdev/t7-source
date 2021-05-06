// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_util;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _pda_hack;

/*
	Name: __init__sytem__
	Namespace: _pda_hack
	Checksum: 0x2DF759D0
	Offset: 0x180
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("pda_hack", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _pda_hack
	Checksum: 0x99EC1590
	Offset: 0x1C0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

#namespace chackableobject;

/*
	Name: __constructor
	Namespace: chackableobject
	Checksum: 0xEFC64391
	Offset: 0x1D0
	Size: 0x80
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	self.m_is_functional = 1;
	self.m_is_hackable = 0;
	self.m_is_trigger_thread_active = 0;
	self.m_n_hack_duration = 2;
	self.m_n_hack_radius = 72;
	self.m_n_hack_height = 128;
	self.m_hack_complete_func = &hacking_completed;
	self.m_does_hack_time_scale = 0;
	self.m_str_team = "axis";
}

/*
	Name: __destructor
	Namespace: chackableobject
	Checksum: 0xF9B0C4B0
	Offset: 0x258
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function __destructor()
{
	clean_up();
}

/*
	Name: setup_hackable_object
	Namespace: chackableobject
	Checksum: 0xDF0F4703
	Offset: 0x278
	Size: 0x194
	Parameters: 5
	Flags: None
*/
function setup_hackable_object(v_origin, str_hint_string, v_angles, func_on_completion, e_reference)
{
	/#
		assert(isdefined(v_origin), "");
	#/
	if(!isdefined(v_angles))
	{
		v_angles = (0, 0, 0);
	}
	self.m_str_hackable_hint = str_hint_string;
	self.m_hack_custom_complete_func = func_on_completion;
	self.m_e_reference = e_reference;
	self.m_e_hack_trigger = spawn_hackable_trigger(v_origin, self.m_n_hack_radius, self.m_n_hack_height, self.m_str_hackable_hint);
	self.m_e_hack_trigger.angles = v_angles;
	self.m_e_origin = spawn("script_model", v_origin);
	self.m_e_origin setmodel("");
	self.m_e_origin notsolid();
	/#
		assert(!self.m_is_hackable, "");
	#/
	self.m_is_hackable = 1;
	enable_hacking();
	self thread thread_hacking_progress();
}

/*
	Name: set_custom_hack_time
	Namespace: chackableobject
	Checksum: 0x4DD10459
	Offset: 0x418
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_custom_hack_time(n_time)
{
	self.m_n_hack_duration = n_time;
}

/*
	Name: enable_hacking
	Namespace: chackableobject
	Checksum: 0x198D3C44
	Offset: 0x438
	Size: 0xCC
	Parameters: 0
	Flags: None
*/
function enable_hacking()
{
	if(self.m_is_hackable)
	{
		if(self.m_str_team != "allies")
		{
			self.m_e_hack_trigger sethintstring(self.m_str_hackable_hint);
			self.m_e_hack_trigger sethintlowpriority(1);
			if(!self.m_is_trigger_thread_active)
			{
				self thread thread_hacking_progress();
			}
		}
		else
		{
			self.m_e_hack_trigger sethintstring("");
			self.m_e_hack_trigger sethintlowpriority(1);
		}
	}
}

/*
	Name: disable_hacking
	Namespace: chackableobject
	Checksum: 0xE5FD5D41
	Offset: 0x510
	Size: 0x68
	Parameters: 0
	Flags: None
*/
function disable_hacking()
{
	if(self.m_is_hackable)
	{
		self notify(#"hacking_disabled");
		self.m_e_hack_trigger sethintstring("");
		self.m_e_hack_trigger sethintlowpriority(1);
		self.m_is_trigger_thread_active = 0;
	}
}

/*
	Name: hacking_completed
	Namespace: chackableobject
	Checksum: 0x3C8995CA
	Offset: 0x580
	Size: 0xB8
	Parameters: 1
	Flags: None
*/
function hacking_completed(e_triggerer)
{
	self notify(#"hacking_completed");
	self.m_str_team = "allies";
	self.m_e_hack_trigger sethintstring("");
	self.m_e_hack_trigger sethintlowpriority(1);
	if(isdefined(self.m_e_reference))
	{
		e_reference = self.m_e_reference;
	}
	else
	{
		e_reference = self;
	}
	if(isdefined(self.m_hack_custom_complete_func))
	{
		e_reference [[self.m_hack_custom_complete_func]]();
	}
}

/*
	Name: wait_till_hacking_completed
	Namespace: chackableobject
	Checksum: 0x7A93950C
	Offset: 0x640
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function wait_till_hacking_completed()
{
	self waittill(#"hacking_completed");
}

/*
	Name: thread_hacking_progress
	Namespace: chackableobject
	Checksum: 0xD41B1DB0
	Offset: 0x658
	Size: 0x558
	Parameters: 0
	Flags: None
*/
function thread_hacking_progress()
{
	self endon(#"hacking_completed");
	self endon(#"hacking_disabled");
	self.m_e_hack_trigger endon(#"death");
	self.m_is_trigger_thread_active = 1;
	self.m_e_hack_trigger sethintstring("");
	self.m_e_hack_trigger sethintlowpriority(1);
	while(true)
	{
		self.m_e_hack_trigger waittill(#"trigger", e_triggerer);
		if(!self.m_is_functional)
		{
			continue;
		}
		if(!e_triggerer util::is_player_looking_at(self.m_e_hack_trigger.origin, 0.75, 0))
		{
			self.m_e_hack_trigger sethintstring("");
			self.m_e_hack_trigger sethintlowpriority(1);
			continue;
		}
		self.m_e_hack_trigger sethintstring(self.m_str_hackable_hint);
		self.m_e_hack_trigger sethintlowpriority(1);
		if(!e_triggerer usebuttonpressed())
		{
			continue;
		}
		foreach(var_8f437e80, player in level.players)
		{
			if(player != e_triggerer)
			{
				self.m_e_hack_trigger sethintstringforplayer(player, "");
			}
		}
		level.primaryprogressbarx = 0;
		level.primaryprogressbary = 110;
		level.primaryprogressbarheight = 8;
		level.primaryprogressbarwidth = 120;
		level.primaryprogressbary_ss = 280;
		e_triggerer temp_player_lock_in_place(self.m_e_hack_trigger);
		wait(0.8);
		n_start_time = 0;
		n_hack_time = self.m_n_hack_duration;
		if(self.m_does_hack_time_scale)
		{
			if(isdefined(level.n_hack_time_multiplier))
			{
				n_hack_time = n_hack_time * level.n_hack_time_multiplier;
			}
		}
		n_hack_range_sq = self.m_n_hack_radius * self.m_n_hack_radius;
		n_user_dist_sq = distance2dsquared(e_triggerer.origin, self.m_e_hack_trigger.origin);
		if(n_user_dist_sq > n_hack_range_sq)
		{
			n_hack_range_sq = n_user_dist_sq;
		}
		b_looking = 1;
		while(n_start_time < n_hack_time && e_triggerer usebuttonpressed() && n_user_dist_sq <= n_hack_range_sq && b_looking)
		{
			n_start_time = n_start_time + 0.05;
			if(!isdefined(self.m_progress_bar))
			{
				self.m_progress_bar = e_triggerer hud::createprimaryprogressbar();
				self.m_progress_bar thread do_bar_update(n_hack_time);
			}
			wait(0.05);
			n_user_dist_sq = distance2dsquared(e_triggerer.origin, self.m_e_hack_trigger.origin);
			b_lookig = e_triggerer util::is_player_looking_at(self.m_e_hack_trigger.origin, 0.75, 0);
		}
		if(isdefined(self.m_progress_bar))
		{
			self.m_progress_bar notify(#"kill_bar");
			self.m_progress_bar hud::destroyelem();
		}
		e_triggerer temp_player_lock_in_place_remove();
		if(n_start_time >= n_hack_time)
		{
			if(self.m_does_hack_time_scale)
			{
				if(!isdefined(level.n_hack_time_multiplier))
				{
					level.n_hack_time_multiplier = 1;
				}
				level.n_hack_time_multiplier = level.n_hack_time_multiplier + 0.2;
			}
			self thread [[self.m_hack_complete_func]](e_triggerer);
		}
		while(e_triggerer usebuttonpressed())
		{
			wait(0.1);
		}
	}
}

/*
	Name: temp_player_lock_in_place
	Namespace: chackableobject
	Checksum: 0x521E01B5
	Offset: 0xBB8
	Size: 0x174
	Parameters: 1
	Flags: None
*/
function temp_player_lock_in_place(trigger)
{
	v_lock_position = trigger.origin + vectornormalize(anglestoforward(trigger.angles)) * 50;
	v_lock_position_ground = bullettrace(v_lock_position, v_lock_position - vectorscale((0, 0, 1), 100), 0, undefined)["position"];
	v_lock_angles = (0, vectortoangles(vectorscale(anglestoforward(trigger.angles), -1))[1], 0);
	self.circuit_breaker_lock_ent = spawn("script_origin", v_lock_position_ground);
	self.circuit_breaker_lock_ent.angles = v_lock_angles;
	self playerlinkto(self.circuit_breaker_lock_ent, undefined, 0, 0, 0, 0, 0);
	self disableweapons();
}

/*
	Name: temp_player_lock_in_place_remove
	Namespace: chackableobject
	Checksum: 0xE9339F6B
	Offset: 0xD38
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function temp_player_lock_in_place_remove()
{
	if(isdefined(self) && isdefined(self.circuit_breaker_lock_ent))
	{
		self unlink();
		self.circuit_breaker_lock_ent delete();
		self enableweapons();
	}
}

/*
	Name: do_bar_update
	Namespace: chackableobject
	Checksum: 0x6AB3A10C
	Offset: 0xDA0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function do_bar_update(n_hack_duration)
{
	self endon(#"kill_bar");
	self hud::updatebar(0.01, 1 / n_hack_duration);
}

/*
	Name: spawn_hackable_trigger
	Namespace: chackableobject
	Checksum: 0x6F1C2CFE
	Offset: 0xDE8
	Size: 0x168
	Parameters: 4
	Flags: None
*/
function spawn_hackable_trigger(v_origin, n_radius, n_height, str_hint)
{
	/#
		assert(isdefined(v_origin), "");
	#/
	/#
		assert(isdefined(n_radius), "");
	#/
	/#
		assert(isdefined(n_height), "");
	#/
	e_trigger = spawn("trigger_radius", v_origin, 0, n_radius, n_height);
	e_trigger triggerignoreteam();
	e_trigger setvisibletoall();
	e_trigger setteamfortrigger("none");
	e_trigger setcursorhint("HINT_NOICON");
	if(isdefined(str_hint))
	{
		e_trigger sethintstring(str_hint);
	}
	return e_trigger;
}

/*
	Name: clean_up
	Namespace: chackableobject
	Checksum: 0xA83BF92C
	Offset: 0xF58
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function clean_up()
{
	if(isdefined(self.m_e_hack_trigger))
	{
		self.m_e_hack_trigger delete();
	}
}

#namespace _pda_hack;

/*
	Name: chackableobject
	Namespace: _pda_hack
	Checksum: 0xD600D653
	Offset: 0xF90
	Size: 0x2C6
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function chackableobject()
{
	classes.chackableobject[0] = spawnstruct();
	classes.chackableobject[0].__vtable[1124446108] = &chackableobject::clean_up;
	classes.chackableobject[0].__vtable[1127628943] = &chackableobject::spawn_hackable_trigger;
	classes.chackableobject[0].__vtable[1660593716] = &chackableobject::do_bar_update;
	classes.chackableobject[0].__vtable[-137001840] = &chackableobject::temp_player_lock_in_place_remove;
	classes.chackableobject[0].__vtable[-507111547] = &chackableobject::temp_player_lock_in_place;
	classes.chackableobject[0].__vtable[874216513] = &chackableobject::thread_hacking_progress;
	classes.chackableobject[0].__vtable[-833227526] = &chackableobject::wait_till_hacking_completed;
	classes.chackableobject[0].__vtable[-49898028] = &chackableobject::hacking_completed;
	classes.chackableobject[0].__vtable[912020471] = &chackableobject::disable_hacking;
	classes.chackableobject[0].__vtable[1694450976] = &chackableobject::enable_hacking;
	classes.chackableobject[0].__vtable[1464933211] = &chackableobject::set_custom_hack_time;
	classes.chackableobject[0].__vtable[-2138253858] = &chackableobject::setup_hackable_object;
	classes.chackableobject[0].__vtable[1606033458] = &chackableobject::__destructor;
	classes.chackableobject[0].__vtable[-1690805083] = &chackableobject::__constructor;
}

