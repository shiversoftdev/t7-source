// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\gametypes\_save;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\stealth_actor;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_level;
#using scripts\shared\stealth_player;
#using scripts\shared\stealth_vehicle;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace stealth;

/*
	Name: __init__sytem__
	Namespace: stealth
	Checksum: 0x5AFA4435
	Offset: 0x2E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("stealth", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: stealth
	Checksum: 0xE79E9038
	Offset: 0x328
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_client_field_callback_funcs();
	/#
		stealth_debug::init();
	#/
}

/*
	Name: init_client_field_callback_funcs
	Namespace: stealth
	Checksum: 0xA2D5E7DF
	Offset: 0x360
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init_client_field_callback_funcs()
{
	clientfield::register("toplayer", "stealth_sighting", 1, 2, "int");
	clientfield::register("toplayer", "stealth_alerted", 1, 1, "int");
}

/*
	Name: init
	Namespace: stealth
	Checksum: 0x78AFA389
	Offset: 0x3D0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level agent_init();
	function_26f24c93(0);
}

/*
	Name: reset
	Namespace: stealth
	Checksum: 0x4FE0527C
	Offset: 0x410
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function reset()
{
	/#
		assert(isdefined(self));
	#/
	if(!isdefined(self.stealth))
	{
		return;
	}
	if(isdefined(self.stealth.agents))
	{
		foreach(agent in self.stealth.agents)
		{
			if(!isdefined(agent))
			{
				continue;
			}
			if(agent == self)
			{
				continue;
			}
			agent function_e8434f94();
		}
	}
	self function_e8434f94();
}

/*
	Name: stop
	Namespace: stealth
	Checksum: 0x6E4C5C02
	Offset: 0x518
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function stop()
{
	/#
		assert(isdefined(self));
	#/
	if(!isdefined(self.stealth))
	{
		return;
	}
	self notify(#"stop_stealth");
	if(isdefined(self.stealth.agents))
	{
		foreach(agent in self.stealth.agents)
		{
			if(!isdefined(agent))
			{
				continue;
			}
			if(agent == self)
			{
				continue;
			}
			agent notify(#"stop_stealth");
			agent agent_stop();
		}
	}
	self agent_stop();
	self.stealth = undefined;
}

/*
	Name: register_agent
	Namespace: stealth
	Checksum: 0x471FABDC
	Offset: 0x648
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function register_agent(object)
{
	if(isdefined(level.stealth))
	{
		if(!isdefined(level.stealth.agents))
		{
			level.stealth.agents = [];
		}
		i = 0;
		for(;;)
		{
			if(!isdefined(level.stealth.agents[i]))
			{
				level.stealth.agents[i] = object;
				return;
			}
			if(level.stealth.agents[i] == object)
			{
				return;
			}
			i++;
		}
	}
}

/*
	Name: agent_init
	Namespace: stealth
	Checksum: 0xCD7962FF
	Offset: 0x708
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function agent_init()
{
	object = self;
	if(!isdefined(object) || isdefined(object.stealth))
	{
		return false;
	}
	if(isplayer(object))
	{
		object stealth_player::init();
	}
	else
	{
		if(isactor(object))
		{
			object stealth_actor::init();
		}
		else
		{
			if(isvehicle(object))
			{
				object stealth_vehicle::init();
			}
			else if(object == level)
			{
				object stealth_level::init();
			}
		}
	}
	register_agent(object);
}

/*
	Name: agent_stop
	Namespace: stealth
	Checksum: 0x76AC27C
	Offset: 0x818
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function agent_stop()
{
	object = self;
	if(!isdefined(object))
	{
		return 0;
	}
	if(isplayer(object))
	{
		return object stealth_player::stop();
	}
	if(isactor(object))
	{
		return object stealth_actor::stop();
	}
	if(isvehicle(object))
	{
		return object stealth_vehicle::stop();
	}
	if(object == level)
	{
		return object stealth_level::stop();
	}
	return 0;
}

/*
	Name: function_e8434f94
	Namespace: stealth
	Checksum: 0x9C994A1B
	Offset: 0x8F8
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function function_e8434f94()
{
	object = self;
	if(!isdefined(object))
	{
		return 0;
	}
	if(isplayer(object))
	{
		return object stealth_player::reset();
	}
	if(isactor(object))
	{
		return object stealth_actor::reset();
	}
	if(isvehicle(object))
	{
		return object stealth_vehicle::reset();
	}
	if(object == level)
	{
		return object stealth_level::reset();
	}
	return 0;
}

/*
	Name: is_enemy
	Namespace: stealth
	Checksum: 0x6B40A2F6
	Offset: 0x9D8
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function is_enemy(entity)
{
	if(!isdefined(entity))
	{
		return 0;
	}
	if(!isdefined(entity.team))
	{
		return 0;
	}
	return entity.team != self.team;
}

/*
	Name: enemy_team
	Namespace: stealth
	Checksum: 0xAB16C39E
	Offset: 0xA28
	Size: 0x62
	Parameters: 0
	Flags: None
*/
function enemy_team()
{
	/#
		assert(isdefined(self.team));
	#/
	switch(self.team)
	{
		case "allies":
		{
			return "axis";
		}
		case "axis":
		{
			return "allies";
		}
	}
	return "allies";
}

/*
	Name: can_see
	Namespace: stealth
	Checksum: 0xDFED3E49
	Offset: 0xA98
	Size: 0x8A
	Parameters: 1
	Flags: Linked
*/
function can_see(entity)
{
	if(isactor(self))
	{
		return self cansee(entity);
	}
	return sighttracepassed(self.origin + vectorscale((0, 0, 1), 30), entity.origin + vectorscale((0, 0, 1), 30), 0, undefined);
}

/*
	Name: awareness_delta
	Namespace: stealth
	Checksum: 0xC9481490
	Offset: 0xB30
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function awareness_delta(str_awarenessa, str_awarenessb)
{
	return level.stealth.awareness_index[str_awarenessa] - level.stealth.awareness_index[str_awarenessb];
}

/*
	Name: level_wait_notify
	Namespace: stealth
	Checksum: 0xA373E532
	Offset: 0xB78
	Size: 0x82
	Parameters: 1
	Flags: None
*/
function level_wait_notify(waitfor)
{
	self notify("level_wait_notify_" + waitfor);
	self endon("level_wait_notify_" + waitfor);
	if(isplayer(self))
	{
		self endon(#"disconnect");
	}
	else
	{
		self endon(#"death");
	}
	self endon(#"stop_stealth");
	level waittill(waitfor);
	self notify(waitfor);
}

/*
	Name: weapon_can_be_reloaded
	Namespace: stealth
	Checksum: 0x877A49B9
	Offset: 0xC08
	Size: 0xC0
	Parameters: 0
	Flags: None
*/
function weapon_can_be_reloaded()
{
	/#
		assert(isplayer(self));
	#/
	w_weapon = self getcurrentweapon();
	i_clip = self getweaponammoclip(w_weapon);
	i_stock = self getweaponammostock(w_weapon);
	return i_clip < w_weapon.clipsize && i_stock > 0;
}

/*
	Name: get_closest_enemy_in_view
	Namespace: stealth
	Checksum: 0x4F2FBFDB
	Offset: 0xCD0
	Size: 0x24A
	Parameters: 2
	Flags: None
*/
function get_closest_enemy_in_view(distance, fov)
{
	level.stealth.enemies[self.team] = array::remove_dead(level.stealth.enemies[self.team]);
	enemies = arraysort(level.stealth.enemies[self.team], self.origin, 20, distance);
	cosfov = cos(fov);
	eyepos = self.origin;
	eyeangles = self.angles;
	if(isplayer(self))
	{
		eyepos = self geteye();
		eyeangles = self getplayerangles();
	}
	else if(isactor(self))
	{
		eyepos = self gettagorigin("TAG_EYE");
		eyeangles = self gettagangles("TAG_EYE");
	}
	foreach(enemy in enemies)
	{
		if(util::within_fov(eyepos, eyeangles, enemy.origin + vectorscale((0, 0, 1), 30), cosfov))
		{
			return enemy;
		}
	}
}

/*
	Name: get_closest_player
	Namespace: stealth
	Checksum: 0x96615B99
	Offset: 0xF28
	Size: 0x98
	Parameters: 2
	Flags: None
*/
function get_closest_player(v_origin, maxdist)
{
	playerlist = getplayers();
	playerlist = arraysortclosest(playerlist, v_origin, 1, 0, maxdist);
	if(isdefined(playerlist) && playerlist.size > 0 && isalive(playerlist[0]))
	{
		return playerlist[0];
	}
}

/*
	Name: awareness_color
	Namespace: stealth
	Checksum: 0x208DDACD
	Offset: 0xFC8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function awareness_color(str_awareness)
{
	if(!isdefined(level.stealth))
	{
		level.stealth = spawnstruct();
	}
	if(!isdefined(level.stealth.awareness_color))
	{
		level.stealth.awareness_color = [];
		level.stealth.awareness_color["unaware"] = vectorscale((1, 1, 1), 0.5);
		level.stealth.awareness_color["low_alert"] = (1, 1, 0);
		level.stealth.awareness_color["high_alert"] = (1, 0.5, 0);
		level.stealth.awareness_color["combat"] = (1, 0, 0);
	}
	return level.stealth.awareness_color[str_awareness];
}

/*
	Name: function_437e9eec
	Namespace: stealth
	Checksum: 0xA6907D65
	Offset: 0x10E0
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_437e9eec(entity)
{
	if(!isdefined(entity))
	{
		return 0;
	}
	if(!isdefined(entity._o_scene))
	{
		return 0;
	}
	if(!isdefined(entity._o_scene._str_state))
	{
		return 0;
	}
	return entity._o_scene._str_state == "play";
}

/*
	Name: function_76c2ffe4
	Namespace: stealth
	Checksum: 0xF42AEFFC
	Offset: 0x1158
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_76c2ffe4(state)
{
	level.stealth.var_bc3590e4 = 1;
	function_e0319e51(state);
}

/*
	Name: function_862e861f
	Namespace: stealth
	Checksum: 0x80508AEB
	Offset: 0x1198
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_862e861f(fade_time)
{
	level.stealth.var_bc3590e4 = 0;
	level.stealth.music_state = "none";
	stealth_music_stop(fade_time);
}

/*
	Name: stealth_music_stop
	Namespace: stealth
	Checksum: 0xF2CF7D32
	Offset: 0x11F0
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function stealth_music_stop(fade_time)
{
	if(isdefined(level.stealth.music_ent))
	{
		foreach(ent in level.stealth.music_ent)
		{
			ent stoploopsound(fade_time);
		}
	}
}

/*
	Name: function_8bb61d8e
	Namespace: stealth
	Checksum: 0x629CD4F4
	Offset: 0x12B0
	Size: 0x7E
	Parameters: 2
	Flags: Linked
*/
function function_8bb61d8e(str_awareness, var_414c0762)
{
	if(!isdefined(level.stealth))
	{
		level.stealth = spawnstruct();
	}
	if(!isdefined(level.stealth.music))
	{
		level.stealth.music = [];
	}
	level.stealth.music[str_awareness] = var_414c0762;
}

/*
	Name: function_e0319e51
	Namespace: stealth
	Checksum: 0xC0CEDF7B
	Offset: 0x1338
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_e0319e51(str_awareness)
{
}

/*
	Name: function_f8aaae39
	Namespace: stealth
	Checksum: 0x6469BB2D
	Offset: 0x13D8
	Size: 0x252
	Parameters: 1
	Flags: Linked
*/
function function_f8aaae39(delay)
{
	if(!isdefined(level.stealth.music_ent))
	{
		if(!isdefined(level.stealth.music_ent))
		{
			level.stealth.music_ent = [];
		}
		level.stealth.music_ent["unaware"] = spawn("script_origin", (0, 0, 0));
		level.stealth.music_ent["low_alert"] = spawn("script_origin", (0, 0, 0));
		level.stealth.music_ent["high_alert"] = spawn("script_origin", (0, 0, 0));
		level.stealth.music_ent["combat"] = spawn("script_origin", (0, 0, 0));
	}
	state = level.stealth.music_state;
	wait(delay);
	if(state == level.stealth.music_state)
	{
		foreach(key, ent in level.stealth.music_ent)
		{
			if(state == key && isdefined(level.stealth.music[key]))
			{
				ent playloopsound(level.stealth.music[key], 1);
				continue;
			}
			ent stoploopsound(3);
		}
	}
}

/*
	Name: function_26f24c93
	Namespace: stealth
	Checksum: 0x36B27617
	Offset: 0x1638
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_26f24c93(b_enabled)
{
	if(isdefined(level.stealth))
	{
		level.stealth.vo_callouts = b_enabled;
	}
	else if(isdefined(b_enabled) && b_enabled)
	{
		/#
			assert(0, "");
		#/
	}
}

/*
	Name: function_9aa26b41
	Namespace: stealth
	Checksum: 0x5FDD6BFC
	Offset: 0x16A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_9aa26b41()
{
	level thread function_762607ad();
}

/*
	Name: function_762607ad
	Namespace: stealth
	Checksum: 0xDC155143
	Offset: 0x16D0
	Size: 0x292
	Parameters: 0
	Flags: Linked, Private
*/
function private function_762607ad()
{
	level notify(#"hash_762607ad");
	level endon(#"hash_762607ad");
	level endon(#"save_restore");
	level endon(#"stop_stealth");
	secondswaited = 0;
	while(secondswaited < 10)
	{
		var_62de14e3 = level stealth_level::enabled() && (level flag::get("stealth_alert") || level flag::get("stealth_combat") || level flag::get("stealth_discovered"));
		if(!var_62de14e3)
		{
			enemies = getaiteamarray("axis");
			for(i = 0; i < enemies.size && !var_62de14e3; i++)
			{
				enemy = enemies[i];
				if(!isdefined(enemy) || isalive(enemy))
				{
					continue;
				}
				if(!enemy stealth_aware::enabled())
				{
					continue;
				}
				foreach(player in level.activeplayers)
				{
					if(enemy getstealthsightvalue(player) > 0)
					{
						var_62de14e3 = 1;
					}
				}
			}
		}
		if(!var_62de14e3)
		{
			var_62de14e3 = !function_fd413bf3();
		}
		if(var_62de14e3)
		{
			wait(1);
			secondswaited++;
			continue;
		}
		else
		{
			savegame::function_fb150717();
			return;
		}
	}
}

/*
	Name: function_fd413bf3
	Namespace: stealth
	Checksum: 0xF43EF3AA
	Offset: 0x1970
	Size: 0xCC
	Parameters: 0
	Flags: Linked, Private
*/
function private function_fd413bf3()
{
	if(!savegame::function_147f4ca3())
	{
		return false;
	}
	ai_enemies = getaiteamarray("axis");
	foreach(enemy in ai_enemies)
	{
		if(!enemy function_d0a01dc8())
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_d0a01dc8
	Namespace: stealth
	Checksum: 0x8600DD5B
	Offset: 0x1A48
	Size: 0x96
	Parameters: 0
	Flags: Linked, Private
*/
function private function_d0a01dc8()
{
	playerproximity = self savegame::function_2808d83d();
	if(playerproximity > 1000 || playerproximity < 0)
	{
		return true;
	}
	if(playerproximity < 500)
	{
		return false;
	}
	if(isactor(self) && self function_ed8df2f())
	{
		return false;
	}
	return true;
}

/*
	Name: function_ed8df2f
	Namespace: stealth
	Checksum: 0xD87F0E0C
	Offset: 0x1AE8
	Size: 0x94
	Parameters: 0
	Flags: Linked, Private
*/
function private function_ed8df2f()
{
	foreach(player in level.activeplayers)
	{
		if(self cansee(player))
		{
			return true;
		}
	}
	return false;
}

