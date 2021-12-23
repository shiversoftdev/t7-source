// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace mgturret;

/*
	Name: main
	Namespace: mgturret
	Checksum: 0xF9016EA1
	Offset: 0x160
	Size: 0xCE
	Parameters: 0
	Flags: None
*/
function main()
{
	if(getdvarstring("mg42") == "")
	{
		setdvar("mgTurret", "off");
	}
	level.magic_distance = 24;
	turretinfos = getentarray("turretInfo", "targetname");
	for(index = 0; index < turretinfos.size; index++)
	{
		turretinfos[index] delete();
	}
}

/*
	Name: set_difficulty
	Namespace: mgturret
	Checksum: 0x56048DA8
	Offset: 0x238
	Size: 0x136
	Parameters: 1
	Flags: None
*/
function set_difficulty(difficulty)
{
	init_turret_difficulty_settings();
	turrets = getentarray("misc_turret", "classname");
	for(index = 0; index < turrets.size; index++)
	{
		if(isdefined(turrets[index].script_skilloverride))
		{
			switch(turrets[index].script_skilloverride)
			{
				case "easy":
				{
					difficulty = "easy";
					break;
				}
				case "medium":
				{
					difficulty = "medium";
					break;
				}
				case "hard":
				{
					difficulty = "hard";
					break;
				}
				case "fu":
				{
					difficulty = "fu";
					break;
				}
				default:
				{
					continue;
				}
			}
		}
		turret_set_difficulty(turrets[index], difficulty);
	}
}

/*
	Name: init_turret_difficulty_settings
	Namespace: mgturret
	Checksum: 0xF0E40869
	Offset: 0x378
	Size: 0x2C4
	Parameters: 0
	Flags: None
*/
function init_turret_difficulty_settings()
{
	level.mgturretsettings["easy"]["convergenceTime"] = 2.5;
	level.mgturretsettings["easy"]["suppressionTime"] = 3;
	level.mgturretsettings["easy"]["accuracy"] = 0.38;
	level.mgturretsettings["easy"]["aiSpread"] = 2;
	level.mgturretsettings["easy"]["playerSpread"] = 0.5;
	level.mgturretsettings["medium"]["convergenceTime"] = 1.5;
	level.mgturretsettings["medium"]["suppressionTime"] = 3;
	level.mgturretsettings["medium"]["accuracy"] = 0.38;
	level.mgturretsettings["medium"]["aiSpread"] = 2;
	level.mgturretsettings["medium"]["playerSpread"] = 0.5;
	level.mgturretsettings["hard"]["convergenceTime"] = 0.8;
	level.mgturretsettings["hard"]["suppressionTime"] = 3;
	level.mgturretsettings["hard"]["accuracy"] = 0.38;
	level.mgturretsettings["hard"]["aiSpread"] = 2;
	level.mgturretsettings["hard"]["playerSpread"] = 0.5;
	level.mgturretsettings["fu"]["convergenceTime"] = 0.4;
	level.mgturretsettings["fu"]["suppressionTime"] = 3;
	level.mgturretsettings["fu"]["accuracy"] = 0.38;
	level.mgturretsettings["fu"]["aiSpread"] = 2;
	level.mgturretsettings["fu"]["playerSpread"] = 0.5;
}

/*
	Name: turret_set_difficulty
	Namespace: mgturret
	Checksum: 0x5AB4A294
	Offset: 0x648
	Size: 0xC8
	Parameters: 2
	Flags: None
*/
function turret_set_difficulty(turret, difficulty)
{
	turret.convergencetime = level.mgturretsettings[difficulty]["convergenceTime"];
	turret.suppressiontime = level.mgturretsettings[difficulty]["suppressionTime"];
	turret.accuracy = level.mgturretsettings[difficulty]["accuracy"];
	turret.aispread = level.mgturretsettings[difficulty]["aiSpread"];
	turret.playerspread = level.mgturretsettings[difficulty]["playerSpread"];
}

/*
	Name: turret_suppression_fire
	Namespace: mgturret
	Checksum: 0xD8047C6A
	Offset: 0x718
	Size: 0xC4
	Parameters: 1
	Flags: None
*/
function turret_suppression_fire(targets)
{
	self endon(#"death");
	self endon(#"stop_suppression_fire");
	if(!isdefined(self.suppresionfire))
	{
		self.suppresionfire = 1;
	}
	for(;;)
	{
		while(self.suppresionfire)
		{
			self settargetentity(targets[randomint(targets.size)]);
			wait(2 + randomfloat(2));
		}
		self cleartargetentity();
		while(!self.suppresionfire)
		{
			wait(1);
		}
	}
}

/*
	Name: burst_fire_settings
	Namespace: mgturret
	Checksum: 0xFB106269
	Offset: 0x7E8
	Size: 0x76
	Parameters: 1
	Flags: None
*/
function burst_fire_settings(setting)
{
	if(setting == "delay")
	{
		return 0.2;
	}
	if(setting == "delay_range")
	{
		return 0.5;
	}
	if(setting == "burst")
	{
		return 0.5;
	}
	if(setting == "burst_range")
	{
		return 4;
	}
}

/*
	Name: burst_fire
	Namespace: mgturret
	Checksum: 0x3E0D20F1
	Offset: 0x868
	Size: 0x24A
	Parameters: 2
	Flags: None
*/
function burst_fire(turret, manual_target)
{
	turret endon(#"death");
	turret endon(#"stopfiring");
	self endon(#"stop_using_built_in_burst_fire");
	if(isdefined(turret.script_delay_min))
	{
		turret_delay = turret.script_delay_min;
	}
	else
	{
		turret_delay = burst_fire_settings("delay");
	}
	if(isdefined(turret.script_delay_max))
	{
		turret_delay_range = turret.script_delay_max - turret_delay;
	}
	else
	{
		turret_delay_range = burst_fire_settings("delay_range");
	}
	if(isdefined(turret.script_burst_min))
	{
		turret_burst = turret.script_burst_min;
	}
	else
	{
		turret_burst = burst_fire_settings("burst");
	}
	if(isdefined(turret.script_burst_max))
	{
		turret_burst_range = turret.script_burst_max - turret_burst;
	}
	else
	{
		turret_burst_range = burst_fire_settings("burst_range");
	}
	while(true)
	{
		turret startfiring();
		if(isdefined(manual_target))
		{
			turret thread random_spread(manual_target);
		}
		turret do_shoot();
		wait(turret_burst + randomfloat(turret_burst_range));
		turret stopshootturret();
		turret stopfiring();
		wait(turret_delay + randomfloat(turret_delay_range));
	}
}

/*
	Name: burst_fire_unmanned
	Namespace: mgturret
	Checksum: 0x2FE92454
	Offset: 0xAC0
	Size: 0x37C
	Parameters: 0
	Flags: None
*/
function burst_fire_unmanned()
{
	self notify(#"stop_burst_fire_unmanned");
	self endon(#"stop_burst_fire_unmanned");
	self endon(#"death");
	self endon(#"remote_start");
	level endon(#"game_ended");
	if(isdefined(self.controlled) && self.controlled)
	{
		return;
	}
	if(isdefined(self.script_delay_min))
	{
		turret_delay = self.script_delay_min;
	}
	else
	{
		turret_delay = burst_fire_settings("delay");
	}
	if(isdefined(self.script_delay_max))
	{
		turret_delay_range = self.script_delay_max - turret_delay;
	}
	else
	{
		turret_delay_range = burst_fire_settings("delay_range");
	}
	if(isdefined(self.script_burst_min))
	{
		turret_burst = self.script_burst_min;
	}
	else
	{
		turret_burst = burst_fire_settings("burst");
	}
	if(isdefined(self.script_burst_max))
	{
		turret_burst_range = self.script_burst_max - turret_burst;
	}
	else
	{
		turret_burst_range = burst_fire_settings("burst_range");
	}
	pauseuntiltime = gettime();
	turretstate = "start";
	self.script_shooting = 0;
	for(;;)
	{
		if(isdefined(self.manual_targets))
		{
			self cleartargetentity();
			self settargetentity(self.manual_targets[randomint(self.manual_targets.size)]);
		}
		duration = (pauseuntiltime - gettime()) * 0.001;
		if(self isfiringturret() && duration <= 0)
		{
			if(turretstate != "fire")
			{
				turretstate = "fire";
				self playsound("mpl_turret_alert");
				self thread do_shoot();
				self.script_shooting = 1;
			}
			duration = turret_burst + randomfloat(turret_burst_range);
			self thread turret_timer(duration);
			self waittill(#"turretstatechange");
			self.script_shooting = 0;
			duration = turret_delay + randomfloat(turret_delay_range);
			pauseuntiltime = gettime() + (int(duration * 1000));
			continue;
		}
		if(turretstate != "aim")
		{
			turretstate = "aim";
		}
		self thread turret_timer(duration);
		self waittill(#"turretstatechange");
	}
}

/*
	Name: do_shoot
	Namespace: mgturret
	Checksum: 0x78291603
	Offset: 0xE48
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function do_shoot()
{
	self endon(#"death");
	self endon(#"turretstatechange");
	for(;;)
	{
		self shootturret();
		wait(0.112);
	}
}

/*
	Name: turret_timer
	Namespace: mgturret
	Checksum: 0xB7F54540
	Offset: 0xE88
	Size: 0x42
	Parameters: 1
	Flags: None
*/
function turret_timer(duration)
{
	if(duration <= 0)
	{
		return;
	}
	self endon(#"turretstatechange");
	wait(duration);
	if(isdefined(self))
	{
		self notify(#"turretstatechange");
	}
}

/*
	Name: random_spread
	Namespace: mgturret
	Checksum: 0x5B1682BF
	Offset: 0xED8
	Size: 0x13C
	Parameters: 1
	Flags: None
*/
function random_spread(ent)
{
	self endon(#"death");
	self notify(#"hash_d175a918");
	self endon(#"hash_d175a918");
	self endon(#"stopfiring");
	self settargetentity(ent);
	self.manual_target = ent;
	while(true)
	{
		if(isplayer(ent))
		{
			ent.origin = self.manual_target getorigin();
		}
		else
		{
			ent.origin = self.manual_target.origin;
		}
		ent.origin = ent.origin + (20 - randomfloat(40), 20 - randomfloat(40), 20 - randomfloat(60));
		wait(0.2);
	}
}

