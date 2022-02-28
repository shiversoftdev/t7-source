// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicleriders_shared;

#namespace turret;

/*
	Name: __init__sytem__
	Namespace: turret
	Checksum: 0x2C3A248F
	Offset: 0x3C0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("turret", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: turret
	Checksum: 0xA042237E
	Offset: 0x400
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "toggle_lensflare", 1, 1, "int");
	level._turrets = spawnstruct();
}

/*
	Name: get_weapon
	Namespace: turret
	Checksum: 0xBDCFFCAD
	Offset: 0x458
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function get_weapon(n_index = 0)
{
	w_weapon = self seatgetweapon(n_index);
	return w_weapon;
}

/*
	Name: get_parent
	Namespace: turret
	Checksum: 0x6FB500B1
	Offset: 0x4A8
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function get_parent(n_index)
{
	return _get_turret_data(n_index).e_parent;
}

/*
	Name: laser_death_watcher
	Namespace: turret
	Checksum: 0x541F3AAC
	Offset: 0x4E0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function laser_death_watcher()
{
	self notify(#"laser_death_thread_stop");
	self endon(#"laser_death_thread_stop");
	self waittill(#"death");
	if(isdefined(self))
	{
		self laseroff();
	}
}

/*
	Name: enable_laser
	Namespace: turret
	Checksum: 0x5FF49E80
	Offset: 0x538
	Size: 0xAA
	Parameters: 2
	Flags: None
*/
function enable_laser(b_enable, n_index)
{
	if(b_enable)
	{
		_get_turret_data(n_index).has_laser = 1;
		self laseron();
		self thread laser_death_watcher();
	}
	else
	{
		_get_turret_data(n_index).has_laser = undefined;
		self laseroff();
		self notify(#"laser_death_thread_stop");
	}
}

/*
	Name: watch_for_flash
	Namespace: turret
	Checksum: 0x6856F4B4
	Offset: 0x5F0
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function watch_for_flash()
{
	self endon(#"watch_for_flash_and_stun");
	self endon(#"death");
	while(true)
	{
		self waittill(#"flashbang", pct_dist, pct_angle, attacker, team);
		self notify(#"damage", 1, attacker, undefined, undefined, undefined, undefined, undefined, undefined, "flash_grenade");
	}
}

/*
	Name: watch_for_flash_and_stun
	Namespace: turret
	Checksum: 0xA9A554A2
	Offset: 0x688
	Size: 0x132
	Parameters: 1
	Flags: Linked
*/
function watch_for_flash_and_stun(n_index)
{
	self notify(#"watch_for_flash_and_stun_end");
	self endon(#"watch_for_flash_and_stun");
	self endon(#"death");
	self thread watch_for_flash();
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction, point, type, tagname, modelname, partname, weapon);
		if(weapon.dostun)
		{
			if(isdefined(self.stunned))
			{
				continue;
			}
			self.stunned = 1;
			stop(n_index, 1);
			wait(randomfloatrange(5, 7));
			self.stunned = undefined;
		}
	}
}

/*
	Name: emp_watcher
	Namespace: turret
	Checksum: 0xCEAE790A
	Offset: 0x7C8
	Size: 0x190
	Parameters: 1
	Flags: Linked
*/
function emp_watcher(n_index)
{
	self notify(#"emp_thread_stop");
	self endon(#"emp_thread_stop");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction, point, type, tagname, modelname, partname, weapon);
		if(weapon.isemp)
		{
			if(isdefined(self.emped))
			{
				continue;
			}
			self.emped = 1;
			if(isdefined(_get_turret_data(n_index).has_laser))
			{
				self laseroff();
			}
			stop(n_index, 1);
			wait(randomfloatrange(5, 7));
			self.emped = undefined;
			if(isdefined(_get_turret_data(n_index).has_laser))
			{
				self laseron();
			}
		}
	}
}

/*
	Name: enable_emp
	Namespace: turret
	Checksum: 0x3166DD5A
	Offset: 0x960
	Size: 0x8E
	Parameters: 2
	Flags: None
*/
function enable_emp(b_enable, n_index)
{
	if(b_enable)
	{
		_get_turret_data(n_index).can_emp = 1;
		self thread emp_watcher(n_index);
		self.takedamage = 1;
	}
	else
	{
		_get_turret_data(n_index).can_emp = undefined;
		self notify(#"emp_thread_stop");
	}
}

/*
	Name: set_team
	Namespace: turret
	Checksum: 0xCDE2771F
	Offset: 0x9F8
	Size: 0x40
	Parameters: 2
	Flags: None
*/
function set_team(str_team, n_index)
{
	_get_turret_data(n_index).str_team = str_team;
	self.team = str_team;
}

/*
	Name: get_team
	Namespace: turret
	Checksum: 0xA6CB8254
	Offset: 0xA40
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function get_team(n_index)
{
	str_team = undefined;
	s_turret = _get_turret_data(n_index);
	str_team = self.team;
	if(!isdefined(s_turret.str_team))
	{
		s_turret.str_team = str_team;
	}
	return str_team;
}

/*
	Name: is_turret_enabled
	Namespace: turret
	Checksum: 0x1A1DB359
	Offset: 0xAC0
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function is_turret_enabled(n_index)
{
	return _get_turret_data(n_index).is_enabled;
}

/*
	Name: does_need_user
	Namespace: turret
	Checksum: 0xAF8C1F38
	Offset: 0xAF8
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function does_need_user(n_index)
{
	return isdefined(_get_turret_data(n_index).b_needs_user) && _get_turret_data(n_index).b_needs_user;
}

/*
	Name: does_have_user
	Namespace: turret
	Checksum: 0x66E39776
	Offset: 0xB50
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function does_have_user(n_index)
{
	return isalive(get_user(n_index));
}

/*
	Name: get_user
	Namespace: turret
	Checksum: 0x76ED8CE9
	Offset: 0xB90
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function get_user(n_index)
{
	return self getseatoccupant(n_index);
}

/*
	Name: _set_turret_needs_user
	Namespace: turret
	Checksum: 0x7A64F78A
	Offset: 0xBC0
	Size: 0x90
	Parameters: 2
	Flags: Linked
*/
function _set_turret_needs_user(n_index, b_needs_user)
{
	s_turret = _get_turret_data(n_index);
	if(b_needs_user)
	{
		s_turret.b_needs_user = 1;
		self thread watch_for_flash_and_stun(n_index);
	}
	else
	{
		self notify(#"watch_for_flash_and_stun_end");
		s_turret.b_needs_user = 0;
	}
}

/*
	Name: set_target_ent_array
	Namespace: turret
	Checksum: 0xCEE186C6
	Offset: 0xC58
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function set_target_ent_array(a_ents, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.priority_target_array = a_ents;
}

/*
	Name: add_priority_target
	Namespace: turret
	Checksum: 0xF797F3BE
	Offset: 0xCB0
	Size: 0xCC
	Parameters: 2
	Flags: None
*/
function add_priority_target(ent_or_ent_array, n_index)
{
	s_turret = _get_turret_data(n_index);
	if(!isarray(ent_or_ent_array))
	{
		a_new_targets = [];
		a_new_targets[0] = ent_or_ent_array;
	}
	else
	{
		a_new_targets = ent_or_ent_array;
	}
	if(isdefined(s_turret.priority_target_array))
	{
		a_new_targets = arraycombine(s_turret.priority_target_array, a_new_targets, 1, 0);
	}
	s_turret.priority_target_array = a_new_targets;
}

/*
	Name: clear_target_ent_array
	Namespace: turret
	Checksum: 0xEFF5ACF6
	Offset: 0xD88
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function clear_target_ent_array(n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.priority_target_array = undefined;
}

/*
	Name: set_ignore_ent_array
	Namespace: turret
	Checksum: 0x36423600
	Offset: 0xDD0
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function set_ignore_ent_array(a_ents, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.a_ignore_target_array = a_ents;
}

/*
	Name: clear_ignore_ent_array
	Namespace: turret
	Checksum: 0xBD62AB5A
	Offset: 0xE28
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function clear_ignore_ent_array(n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.a_ignore_target_array = undefined;
}

/*
	Name: _wait_for_current_user_to_finish
	Namespace: turret
	Checksum: 0x3A8D2583
	Offset: 0xE70
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function _wait_for_current_user_to_finish(n_index)
{
	self endon(#"death");
	while(isalive(get_user(n_index)))
	{
		wait(0.05);
	}
}

/*
	Name: is_current_user
	Namespace: turret
	Checksum: 0xA03BF0BD
	Offset: 0xEC8
	Size: 0x58
	Parameters: 2
	Flags: None
*/
function is_current_user(ai_user, n_index)
{
	ai_current_user = get_user(n_index);
	return isalive(ai_current_user) && ai_user == ai_current_user;
}

/*
	Name: set_burst_parameters
	Namespace: turret
	Checksum: 0xA6F941E2
	Offset: 0xF28
	Size: 0xA0
	Parameters: 5
	Flags: Linked
*/
function set_burst_parameters(n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.n_burst_fire_min = n_fire_min;
	s_turret.n_burst_fire_max = n_fire_max;
	s_turret.n_burst_wait_min = n_wait_min;
	s_turret.n_burst_wait_max = n_wait_max;
}

/*
	Name: set_torso_targetting
	Namespace: turret
	Checksum: 0x254C4F6D
	Offset: 0xFD0
	Size: 0x5C
	Parameters: 2
	Flags: None
*/
function set_torso_targetting(n_index, n_torso_targetting_offset = -12)
{
	s_turret = _get_turret_data(n_index);
	s_turret.n_torso_targetting_offset = n_torso_targetting_offset;
}

/*
	Name: set_target_leading
	Namespace: turret
	Checksum: 0x2A2FCB64
	Offset: 0x1038
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function set_target_leading(n_index, n_target_leading_factor = 0.1)
{
	s_turret = _get_turret_data(n_index);
	s_turret.n_target_leading_factor = n_target_leading_factor;
}

/*
	Name: set_on_target_angle
	Namespace: turret
	Checksum: 0x338191EC
	Offset: 0x10A8
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function set_on_target_angle(n_angle, n_index)
{
	s_turret = _get_turret_data(n_index);
	if(!isdefined(n_angle))
	{
		if(s_turret.str_guidance_type != "none")
		{
			n_angle = 10;
		}
		else
		{
			n_angle = 2;
		}
	}
	if(n_index > 0)
	{
		self setontargetangle(n_angle, n_index - 1);
	}
	else
	{
		self setontargetangle(n_angle);
	}
}

/*
	Name: set_target
	Namespace: turret
	Checksum: 0xF622E3A0
	Offset: 0x1178
	Size: 0x100
	Parameters: 3
	Flags: Linked
*/
function set_target(e_target, v_offset, n_index)
{
	s_turret = _get_turret_data(n_index);
	if(!isdefined(v_offset))
	{
		v_offset = _get_default_target_offset(e_target, n_index);
	}
	if(!isdefined(n_index) || n_index == 0)
	{
		self settargetentity(e_target, v_offset);
	}
	else
	{
		self settargetentity(e_target, v_offset, n_index - 1);
	}
	s_turret.e_target = e_target;
	s_turret.e_last_target = e_target;
	s_turret.v_offset = v_offset;
}

/*
	Name: _get_default_target_offset
	Namespace: turret
	Checksum: 0x72F6A296
	Offset: 0x1280
	Size: 0x2CC
	Parameters: 2
	Flags: Linked
*/
function _get_default_target_offset(e_target, n_index)
{
	s_turret = _get_turret_data(n_index);
	if(s_turret.str_weapon_type == "bullet")
	{
		if(isdefined(e_target))
		{
			if(issentient(self) && issentient(e_target))
			{
				z_offset = (isvehicle(e_target) ? 0 : (isdefined(s_turret.n_torso_targetting_offset) ? s_turret.n_torso_targetting_offset : 0));
			}
			else
			{
				if(isplayer(e_target))
				{
					z_offset = randomintrange(40, 50);
				}
				else
				{
					if(e_target.type === "human")
					{
						z_offset = randomintrange(20, 60);
					}
					else if(e_target.type === "robot")
					{
						z_offset = randomintrange(40, 60);
					}
				}
			}
			if(isdefined(e_target.z_target_offset_override))
			{
				if(!isdefined(z_offset))
				{
					z_offset = 0;
				}
				z_offset = z_offset + e_target.z_target_offset_override;
			}
		}
	}
	if(!isdefined(z_offset))
	{
		z_offset = 0;
	}
	v_offset = (0, 0, z_offset);
	if((isdefined(s_turret.n_target_leading_factor) ? s_turret.n_target_leading_factor : 0) != 0 && isdefined(e_target) && issentient(self) && issentient(e_target) && !isvehicle(e_target))
	{
		velocity = e_target getvelocity();
		v_offset = v_offset + (velocity * s_turret.n_target_leading_factor);
	}
	return v_offset;
}

/*
	Name: get_target
	Namespace: turret
	Checksum: 0x1F63F40E
	Offset: 0x1558
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function get_target(n_index)
{
	if(isdefined(_get_turret_data(n_index).e_target) && (isdefined(_get_turret_data(n_index).e_target.ignoreme) && _get_turret_data(n_index).e_target.ignoreme))
	{
		clear_target(n_index);
	}
	return _get_turret_data(n_index).e_target;
}

/*
	Name: is_target
	Namespace: turret
	Checksum: 0x430564CB
	Offset: 0x1618
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function is_target(e_target, n_index)
{
	e_current_target = get_target(n_index);
	if(isdefined(e_current_target))
	{
		return e_current_target == e_target;
	}
	return 0;
}

/*
	Name: clear_target
	Namespace: turret
	Checksum: 0x7FF10318
	Offset: 0x1670
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function clear_target(n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret flag::clear("turret manual");
	s_turret.e_next_target = undefined;
	s_turret.e_target = undefined;
	if(!isdefined(n_index) || n_index == 0)
	{
		self clearturrettarget();
	}
	else
	{
		self cleargunnertarget(n_index - 1);
	}
}

/*
	Name: set_target_flags
	Namespace: turret
	Checksum: 0x52FD1F36
	Offset: 0x1730
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function set_target_flags(n_flags, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.n_target_flags = n_flags;
}

/*
	Name: _has_target_flags
	Namespace: turret
	Checksum: 0xAB048145
	Offset: 0x1788
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function _has_target_flags(n_flags, n_index)
{
	n_current_flags = _get_turret_data(n_index).n_target_flags;
	return (n_current_flags & n_flags) == n_flags;
}

/*
	Name: set_max_target_distance
	Namespace: turret
	Checksum: 0x1A873DBF
	Offset: 0x17E0
	Size: 0x50
	Parameters: 2
	Flags: None
*/
function set_max_target_distance(n_distance, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.n_max_target_distance_squared = n_distance * n_distance;
}

/*
	Name: set_min_target_distance
	Namespace: turret
	Checksum: 0xEC1B8493
	Offset: 0x1838
	Size: 0x50
	Parameters: 2
	Flags: None
*/
function set_min_target_distance(n_distance, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.n_min_target_distance_squared = n_distance * n_distance;
}

/*
	Name: set_min_target_distance_squared
	Namespace: turret
	Checksum: 0xFAB4E3A2
	Offset: 0x1890
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function set_min_target_distance_squared(n_distance_squared, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.n_min_target_distance_squared = n_distance_squared;
}

/*
	Name: fire
	Namespace: turret
	Checksum: 0x3E83646A
	Offset: 0x18E8
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function fire(n_index)
{
	s_turret = _get_turret_data(n_index);
	/#
		assert(isdefined(n_index) && n_index >= 0, "");
	#/
	if(n_index == 0)
	{
		self fireweapon(0, s_turret.e_target);
	}
	else
	{
		ai_current_user = get_user(n_index);
		if(isdefined(ai_current_user) && (isdefined(ai_current_user.is_disabled) && ai_current_user.is_disabled))
		{
			return;
		}
		if(isdefined(s_turret.e_target))
		{
			self setgunnertargetent(s_turret.e_target, s_turret.v_offset, n_index - 1);
		}
		self fireweapon(n_index, s_turret.e_target, s_turret.v_offset, s_turret.e_parent);
	}
	s_turret.n_last_fire_time = gettime();
}

/*
	Name: stop
	Namespace: turret
	Checksum: 0xE41DF817
	Offset: 0x1A78
	Size: 0xC0
	Parameters: 2
	Flags: Linked
*/
function stop(n_index, b_clear_target = 0)
{
	s_turret = _get_turret_data(n_index);
	s_turret.e_next_target = undefined;
	s_turret.e_target = undefined;
	s_turret flag::clear("turret manual");
	if(b_clear_target)
	{
		clear_target(n_index);
	}
	self notify("_stop_turret" + _index(n_index));
}

/*
	Name: fire_for_time
	Namespace: turret
	Checksum: 0x556569FC
	Offset: 0x1B40
	Size: 0x1EC
	Parameters: 2
	Flags: Linked
*/
function fire_for_time(n_time, n_index = 0)
{
	/#
		assert(isdefined(n_time), "");
	#/
	self endon(#"death");
	self endon(#"drone_death");
	self endon("_stop_turret" + _index(n_index));
	self endon("turret_disabled" + _index(n_index));
	self notify("_fire_turret_for_time" + _index(n_index));
	self endon("_fire_turret_for_time" + _index(n_index));
	b_fire_forever = 0;
	if(n_time < 0)
	{
		b_fire_forever = 1;
	}
	else
	{
		/#
			w_weapon = get_weapon(n_index);
			assert(n_time >= w_weapon.firetime, (("" + n_time) + "") + w_weapon.firetime);
		#/
		/#
		#/
	}
	while(n_time > 0 || b_fire_forever)
	{
		n_burst_time = _burst_fire(n_time, n_index);
		if(!b_fire_forever)
		{
			n_time = n_time - n_burst_time;
		}
	}
}

/*
	Name: shoot_at_target
	Namespace: turret
	Checksum: 0x9CD17921
	Offset: 0x1D38
	Size: 0xF4
	Parameters: 5
	Flags: Linked
*/
function shoot_at_target(e_target, n_time, v_offset, n_index, b_just_once)
{
	/#
		assert(isdefined(e_target), "");
	#/
	self endon(#"drone_death");
	self endon(#"death");
	s_turret = _get_turret_data(n_index);
	s_turret flag::set("turret manual");
	_shoot_turret_at_target(e_target, n_time, v_offset, n_index, b_just_once);
	s_turret flag::clear("turret manual");
}

/*
	Name: _shoot_turret_at_target
	Namespace: turret
	Checksum: 0x45F3A449
	Offset: 0x1E38
	Size: 0x184
	Parameters: 5
	Flags: Linked
*/
function _shoot_turret_at_target(e_target, n_time, v_offset, n_index, b_just_once)
{
	self endon(#"drone_death");
	self endon(#"death");
	self endon("_stop_turret" + _index(n_index));
	self endon("turret_disabled" + _index(n_index));
	self notify("_shoot_turret_at_target" + _index(n_index));
	self endon("_shoot_turret_at_target" + _index(n_index));
	if(n_time == -1)
	{
		e_target endon(#"death");
	}
	if(!isdefined(b_just_once))
	{
		b_just_once = 0;
	}
	set_target(e_target, v_offset, n_index);
	if(!isdefined(self.aim_only_no_shooting))
	{
		_waittill_turret_on_target(e_target, n_index);
		if(b_just_once)
		{
			fire(n_index);
		}
		else
		{
			fire_for_time(n_time, n_index);
		}
	}
}

/*
	Name: _waittill_turret_on_target
	Namespace: turret
	Checksum: 0xECBF66CD
	Offset: 0x1FC8
	Size: 0x90
	Parameters: 2
	Flags: Linked
*/
function _waittill_turret_on_target(e_target, n_index)
{
	do
	{
		wait((isdefined(self.waittill_turret_on_target_delay) ? self.waittill_turret_on_target_delay : 0.5));
		if(!isdefined(n_index) || n_index == 0)
		{
			self waittill(#"turret_on_target");
		}
		else
		{
			self waittill(#"gunner_turret_on_target");
		}
	}
	while(isdefined(e_target) && !can_hit_target(e_target, n_index));
}

/*
	Name: shoot_at_target_once
	Namespace: turret
	Checksum: 0x5D5C9D95
	Offset: 0x2060
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function shoot_at_target_once(e_target, v_offset, n_index)
{
	shoot_at_target(e_target, 0, v_offset, n_index, 1);
}

/*
	Name: enable
	Namespace: turret
	Checksum: 0xAEB71C03
	Offset: 0x20B0
	Size: 0x104
	Parameters: 3
	Flags: Linked
*/
function enable(n_index, b_user_required, v_offset)
{
	if(isalive(self) && !is_turret_enabled(n_index))
	{
		_get_turret_data(n_index).is_enabled = 1;
		self thread _turret_think(n_index, v_offset);
		self notify("turret_enabled" + _index(n_index));
		if(isdefined(b_user_required) && !b_user_required)
		{
			_set_turret_needs_user(n_index, 0);
		}
		else
		{
			_set_turret_needs_user(n_index, 1);
		}
	}
}

/*
	Name: enable_auto_use
	Namespace: turret
	Checksum: 0xB1E10C00
	Offset: 0x21C0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function enable_auto_use(b_enable = 1)
{
	self.script_auto_use = b_enable;
}

/*
	Name: disable_ai_getoff
	Namespace: turret
	Checksum: 0x69DCC48F
	Offset: 0x21F8
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function disable_ai_getoff(n_index, b_disable = 1)
{
	_get_turret_data(n_index).disable_ai_getoff = b_disable;
}

/*
	Name: disable
	Namespace: turret
	Checksum: 0x41D631B2
	Offset: 0x2250
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function disable(n_index)
{
	if(is_turret_enabled(n_index))
	{
		_drop_turret(n_index);
		clear_target(n_index);
		_get_turret_data(n_index).is_enabled = 0;
		self notify("turret_disabled" + _index(n_index));
	}
}

/*
	Name: pause
	Namespace: turret
	Checksum: 0x248DD958
	Offset: 0x22F0
	Size: 0xCC
	Parameters: 2
	Flags: None
*/
function pause(time, n_index)
{
	s_turret = _get_turret_data(n_index);
	if(time > 0)
	{
		time = time * 1000;
	}
	if(isdefined(s_turret.pause))
	{
		s_turret.pause_time = s_turret.pause_time + time;
	}
	else
	{
		s_turret.pause = 1;
		s_turret.pause_time = time;
		stop(n_index);
	}
}

/*
	Name: unpause
	Namespace: turret
	Checksum: 0x85EC86AF
	Offset: 0x23C8
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function unpause(n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.pause = undefined;
}

/*
	Name: _turret_think
	Namespace: turret
	Checksum: 0xFAE79822
	Offset: 0x2410
	Size: 0x566
	Parameters: 2
	Flags: Linked
*/
function _turret_think(n_index, v_offset)
{
	turret_think_time = max(1.5, get_weapon(n_index).firetime);
	no_target_start_time = 0;
	self endon(#"death");
	self endon("turret_disabled" + _index(n_index));
	self notify("_turret_think" + _index(n_index));
	self endon("_turret_think" + _index(n_index));
	/#
		self thread _debug_turret_think(n_index);
	#/
	self thread _turret_user_think(n_index);
	self thread _turret_new_user_think(n_index);
	s_turret = _get_turret_data(n_index);
	if(isdefined(s_turret.has_laser))
	{
		self laseron();
	}
	while(true)
	{
		s_turret flag::wait_till_clear("turret manual");
		n_time_now = gettime();
		if(self _check_for_paused(n_index) || isdefined(self.emped) || isdefined(self.stunned))
		{
			wait(turret_think_time);
			continue;
		}
		a_potential_targets = _get_potential_targets(n_index);
		if(!isdefined(s_turret.e_target) || s_turret.e_target.health < 0 || !isinarray(a_potential_targets, s_turret.e_target) || s_turret _did_turret_lose_target(n_time_now))
		{
			stop(n_index);
		}
		e_original_next_target = s_turret.e_next_target;
		s_turret.e_next_target = _get_best_target_from_potential(a_potential_targets, n_index);
		if(isdefined(s_turret.e_next_target))
		{
			s_turret.b_target_out_of_range = undefined;
			s_turret.n_time_lose_sight = undefined;
			no_target_start_time = 0;
			if(_user_check(n_index))
			{
				self thread _shoot_turret_at_target(s_turret.e_next_target, turret_think_time, v_offset, n_index);
				if(s_turret.e_next_target !== e_original_next_target)
				{
					self notify(#"has_new_target", s_turret.e_next_target);
				}
			}
		}
		else
		{
			if(!isdefined(self.do_not_clear_targets_during_think) || !self.do_not_clear_targets_during_think)
			{
				clear_target(n_index);
			}
			if(no_target_start_time == 0)
			{
				no_target_start_time = n_time_now;
			}
			target_wait_time = n_time_now - no_target_start_time;
			if(isdefined(s_turret.occupy_no_target_time))
			{
				occupy_time = s_turret.occupy_no_target_time;
			}
			else
			{
				occupy_time = 3600;
			}
			if(!(isdefined(s_turret.disable_ai_getoff) && s_turret.disable_ai_getoff))
			{
				bwasplayertarget = isdefined(s_turret.e_last_target) && s_turret.e_last_target.health > 0 && isplayer(s_turret.e_last_target);
				if(bwasplayertarget)
				{
					occupy_time = occupy_time / 4;
				}
			}
			else
			{
				bwasplayertarget = 0;
			}
			if(target_wait_time >= occupy_time)
			{
				_drop_turret(n_index, !bwasplayertarget);
			}
		}
		if(!(isdefined(s_turret.disable_ai_getoff) && s_turret.disable_ai_getoff) && _has_nearby_player_enemy(n_index, self))
		{
			_drop_turret(n_index, 0);
		}
		wait(turret_think_time);
	}
}

/*
	Name: _has_nearby_player_enemy
	Namespace: turret
	Checksum: 0xF00619DF
	Offset: 0x2980
	Size: 0x1FC
	Parameters: 2
	Flags: Linked
*/
function _has_nearby_player_enemy(index, turret)
{
	has_nearby_enemy = 0;
	time = gettime();
	ai_user = turret get_user(index);
	if(!isdefined(ai_user))
	{
		return has_nearby_enemy;
	}
	if(!isdefined(turret.next_nearby_enemy_time))
	{
		turret.next_nearby_enemy_time = time;
	}
	if(time >= turret.next_nearby_enemy_time)
	{
		players = getplayers();
		foreach(player in players)
		{
			if(turret.team == player.team)
			{
				continue;
			}
			if((abs(ai_user.origin[2] - player.origin[2])) <= 60 && distance2dsquared(ai_user.origin, player.origin) <= (300 * 300))
			{
				has_nearby_enemy = 1;
				break;
			}
		}
		turret.next_nearby_enemy_time = time + 1000;
	}
	return has_nearby_enemy;
}

/*
	Name: _did_turret_lose_target
	Namespace: turret
	Checksum: 0x64A6B2D0
	Offset: 0x2B88
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function _did_turret_lose_target(n_time_now)
{
	if(isdefined(self.b_target_out_of_range) && self.b_target_out_of_range)
	{
		return 1;
	}
	if(isdefined(self.n_time_lose_sight))
	{
		return (n_time_now - self.n_time_lose_sight) > 3000;
	}
	return 0;
}

/*
	Name: _turret_user_think
	Namespace: turret
	Checksum: 0xA1C9E856
	Offset: 0x2BE0
	Size: 0x188
	Parameters: 1
	Flags: Linked
*/
function _turret_user_think(n_index)
{
	self endon(#"death");
	self endon("turret_disabled" + _index(n_index));
	self endon("_turret_think" + _index(n_index));
	s_turret = _get_turret_data(n_index);
	ai_user = self getseatoccupant(n_index);
	if(isactor(ai_user))
	{
		self thread _listen_for_damage_on_actor(ai_user, n_index);
	}
	while(true)
	{
		_waittill_user_change(n_index);
		if(!_user_check(n_index))
		{
			stop(n_index, 1);
		}
		else
		{
			ai_user = self getseatoccupant(n_index);
			if(isactor(ai_user))
			{
				self thread _listen_for_damage_on_actor(ai_user, n_index);
			}
		}
	}
}

/*
	Name: _listen_for_damage_on_actor
	Namespace: turret
	Checksum: 0x28F0285
	Offset: 0x2D70
	Size: 0x138
	Parameters: 2
	Flags: Linked
*/
function _listen_for_damage_on_actor(ai_user, n_index)
{
	self endon(#"death");
	ai_user endon(#"death");
	self endon("turret_disabled" + _index(n_index));
	self endon("_turret_think" + _index(n_index));
	self endon(#"exit_vehicle");
	while(true)
	{
		ai_user waittill(#"damage", n_amount, e_attacker, v_org, v_dir, str_mod);
		s_turret = _get_turret_data(n_index);
		if(isdefined(s_turret))
		{
			if(!isdefined(s_turret.e_next_target) && !isdefined(s_turret.e_target))
			{
				s_turret.e_last_target = e_attacker;
			}
		}
	}
}

/*
	Name: _waittill_user_change
	Namespace: turret
	Checksum: 0x306A3EBE
	Offset: 0x2EB0
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function _waittill_user_change(n_index)
{
	ai_user = self getseatoccupant(n_index);
	if(isalive(ai_user))
	{
		if(isactor(ai_user))
		{
			ai_user endon(#"death");
		}
		else if(isplayer(ai_user))
		{
			self notify("turret_disabled" + _index(n_index));
		}
	}
	self util::waittill_either("exit_vehicle", "enter_vehicle");
}

/*
	Name: _check_for_paused
	Namespace: turret
	Checksum: 0xE974A166
	Offset: 0x2F88
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function _check_for_paused(n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.pause_start_time = gettime();
	while(isdefined(s_turret.pause))
	{
		if(s_turret.pause_time > 0)
		{
			time = gettime();
			paused_time = time - s_turret.pause_start_time;
			if(paused_time > s_turret.pause_time)
			{
				s_turret.pause = undefined;
				return true;
			}
		}
		wait(0.05);
	}
	return false;
}

/*
	Name: _drop_turret
	Namespace: turret
	Checksum: 0xC0B6F3BF
	Offset: 0x3068
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function _drop_turret(n_index, bexitifautomatedonly)
{
	ai_user = get_user(n_index);
	if(isalive(ai_user) && (isdefined(ai_user.turret_auto_use) && ai_user.turret_auto_use || (isdefined(bexitifautomatedonly) && !bexitifautomatedonly)))
	{
		ai_user vehicle::get_out();
	}
}

/*
	Name: _turret_new_user_think
	Namespace: turret
	Checksum: 0xD04FD63E
	Offset: 0x3110
	Size: 0x3F8
	Parameters: 1
	Flags: Linked
*/
function _turret_new_user_think(n_index)
{
	self endon(#"death");
	self endon("_turret_think" + _index(n_index));
	self endon("turret_disabled" + _index(n_index));
	s_turret = _get_turret_data(n_index);
	if(n_index == 0)
	{
		str_gunner_pos = "driver";
	}
	else
	{
		str_gunner_pos = "gunner" + n_index;
	}
	while(true)
	{
		wait(3);
		if(does_have_target(n_index) && !_user_check(n_index) && (isdefined(self.script_auto_use) && self.script_auto_use))
		{
			str_team = get_team(n_index);
			a_users = getaiarchetypearray("human", str_team);
			a_ai_by_vehicle = arraysortclosest(getaiarray(), self.origin, 99999, 0, 300);
			if(a_users.size > 0)
			{
				a_potential_users = [];
				if(isdefined(self.script_auto_use_radius))
				{
					a_potential_users = arraysort(a_users, self.origin, 1, a_potential_users.size, self.script_auto_use_radius);
				}
				else
				{
					a_potential_users = arraysort(a_users, self.origin, 1);
				}
				ai_user = undefined;
				foreach(ai in a_potential_users)
				{
					b_enemy_close = 0;
					foreach(ai_enemy in a_ai_by_vehicle)
					{
						if(ai_enemy.team != ai.team)
						{
							b_enemy_close = 1;
							break;
						}
					}
					if(b_enemy_close)
					{
						continue;
					}
					if(ai flagsys::get("vehiclerider"))
					{
						continue;
					}
					if(!ai vehicle::can_get_in(self, str_gunner_pos))
					{
						continue;
					}
					ai_user = ai;
					break;
				}
				if(isalive(ai_user))
				{
					ai_user.turret_auto_use = 1;
					ai_user vehicle::get_in(self, str_gunner_pos);
				}
			}
		}
	}
}

/*
	Name: does_have_target
	Namespace: turret
	Checksum: 0x1EF57C6A
	Offset: 0x3510
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function does_have_target(n_index)
{
	return isdefined(_get_turret_data(n_index).e_next_target);
}

/*
	Name: _user_check
	Namespace: turret
	Checksum: 0xBC7C0F3C
	Offset: 0x3548
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function _user_check(n_index)
{
	s_turret = _get_turret_data(n_index);
	if(does_need_user(n_index))
	{
		b_has_user = does_have_user(n_index);
		return b_has_user;
	}
	return 1;
}

/*
	Name: _debug_turret_think
	Namespace: turret
	Checksum: 0xA74157B8
	Offset: 0x35C8
	Size: 0x350
	Parameters: 1
	Flags: Linked
*/
function _debug_turret_think(n_index)
{
	/#
		self endon(#"death");
		self endon("" + _index(n_index));
		self endon("" + _index(n_index));
		s_turret = _get_turret_data(n_index);
		v_color = (0, 0, 1);
		while(true)
		{
			if(!getdvarint(""))
			{
				wait(0.2);
				continue;
			}
			has_target = isdefined(get_target(n_index));
			if(does_need_user(n_index) && !does_have_user(n_index) || !has_target)
			{
				v_color = (1, 1, 0);
			}
			else
			{
				v_color = (0, 1, 0);
			}
			str_team = get_team(n_index);
			if(!isdefined(str_team))
			{
				str_team = "";
			}
			str_target = "";
			e_target = s_turret.e_next_target;
			if(isdefined(e_target))
			{
				if(isactor(e_target))
				{
					str_target = str_target + "";
				}
				else
				{
					if(isplayer(e_target))
					{
						str_target = str_target + "";
					}
					else
					{
						if(isvehicle(e_target))
						{
							str_target = str_target + "";
						}
						else
						{
							if(isdefined(e_target.targetname) && e_target.targetname == "")
							{
								str_target = str_target + "";
							}
							else if(isdefined(e_target.classname))
							{
								str_target = str_target + e_target.classname;
							}
						}
					}
				}
			}
			else
			{
				str_target = str_target + "";
			}
			str_debug = (((self getentnum() + "") + str_team) + "") + str_target;
			record3dtext(str_debug, self.origin, v_color, "", self);
			wait(0.05);
		}
	#/
}

/*
	Name: _get_turret_data
	Namespace: turret
	Checksum: 0xC9A8CAE5
	Offset: 0x3920
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function _get_turret_data(n_index)
{
	s_turret = undefined;
	if(isvehicle(self))
	{
		if(isdefined(self.a_turrets) && isdefined(self.a_turrets[n_index]))
		{
			s_turret = self.a_turrets[n_index];
		}
	}
	else
	{
		s_turret = self._turret;
	}
	if(!isdefined(s_turret))
	{
		s_turret = _init_turret(n_index);
	}
	return s_turret;
}

/*
	Name: has_turret
	Namespace: turret
	Checksum: 0x7207BF0A
	Offset: 0x39D0
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function has_turret(n_index)
{
	if(isdefined(self.a_turrets) && isdefined(self.a_turrets[n_index]))
	{
		return true;
	}
	return false;
}

/*
	Name: _init_turret
	Namespace: turret
	Checksum: 0xBB246B02
	Offset: 0x3A10
	Size: 0x268
	Parameters: 1
	Flags: Linked
*/
function _init_turret(n_index = 0)
{
	self endon(#"death");
	w_weapon = get_weapon(n_index);
	if(w_weapon == level.weaponnone)
	{
		/#
			assertmsg("");
		#/
		return;
	}
	util::waittill_asset_loaded("xmodel", self.model);
	if(isvehicle(self))
	{
		s_turret = _init_vehicle_turret(n_index);
	}
	else
	{
		/#
			assertmsg("");
		#/
	}
	s_turret.w_weapon = w_weapon;
	_update_turret_arcs(n_index);
	s_turret.is_enabled = 0;
	s_turret.e_parent = self;
	s_turret.e_target = undefined;
	s_turret.b_ignore_line_of_sight = 0;
	s_turret.v_offset = (0, 0, 0);
	s_turret.n_burst_fire_time = 0;
	s_turret.n_max_target_distance_squared = undefined;
	s_turret.n_min_target_distance_squared = undefined;
	s_turret.str_weapon_type = "bullet";
	s_turret.str_guidance_type = "none";
	s_turret.str_weapon_type = w_weapon.type;
	s_turret.str_guidance_type = w_weapon.guidedmissiletype;
	set_on_target_angle(undefined, n_index);
	s_turret.n_target_flags = 3;
	set_best_target_func_from_weapon_type(n_index);
	s_turret flag::init("turret manual");
	return s_turret;
}

/*
	Name: _update_turret_arcs
	Namespace: turret
	Checksum: 0x676DEE1E
	Offset: 0x3C80
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function _update_turret_arcs(n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.rightarc = s_turret.w_weapon.rightarc;
	s_turret.leftarc = s_turret.w_weapon.leftarc;
	s_turret.toparc = s_turret.w_weapon.toparc;
	s_turret.bottomarc = s_turret.w_weapon.bottomarc;
}

/*
	Name: set_best_target_func_from_weapon_type
	Namespace: turret
	Checksum: 0xB9AA2768
	Offset: 0x3D48
	Size: 0x11A
	Parameters: 1
	Flags: Linked
*/
function set_best_target_func_from_weapon_type(n_index)
{
	switch(_get_turret_data(n_index).str_weapon_type)
	{
		case "bullet":
		{
			set_best_target_func(&_get_best_target_bullet, n_index);
			break;
		}
		case "gas":
		{
			set_best_target_func(&_get_best_target_gas, n_index);
			break;
		}
		case "grenade":
		{
			set_best_target_func(&_get_best_target_grenade, n_index);
			break;
		}
		case "projectile":
		{
			set_best_target_func(&_get_best_target_projectile, n_index);
			break;
		}
		default:
		{
			/#
				assertmsg("");
			#/
		}
	}
}

/*
	Name: set_best_target_func
	Namespace: turret
	Checksum: 0xFFCB56FA
	Offset: 0x3E70
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function set_best_target_func(func_get_best_target, n_index)
{
	_get_turret_data(n_index).func_get_best_target = func_get_best_target;
}

/*
	Name: _init_vehicle_turret
	Namespace: turret
	Checksum: 0x42EC0A4B
	Offset: 0x3EB0
	Size: 0x288
	Parameters: 1
	Flags: Linked
*/
function _init_vehicle_turret(n_index)
{
	/#
		assert(isdefined(n_index) && n_index >= 0, "");
	#/
	s_turret = spawnstruct();
	v_angles = self getseatfiringangles(n_index);
	if(isdefined(v_angles))
	{
		s_turret.n_rest_angle_pitch = 0;
		s_turret.n_rest_angle_yaw = 0;
	}
	switch(n_index)
	{
		case 0:
		{
			s_turret.str_tag_flash = "tag_flash";
			s_turret.str_tag_pivot = "tag_barrel";
			break;
		}
		case 1:
		{
			s_turret.str_tag_flash = "tag_gunner_flash1";
			s_turret.str_tag_pivot = "tag_gunner_barrel1";
			break;
		}
		case 2:
		{
			s_turret.str_tag_flash = "tag_gunner_flash2";
			s_turret.str_tag_pivot = "tag_gunner_barrel2";
			break;
		}
		case 3:
		{
			s_turret.str_tag_flash = "tag_gunner_flash3";
			s_turret.str_tag_pivot = "tag_gunner_barrel3";
			break;
		}
		case 4:
		{
			s_turret.str_tag_flash = "tag_gunner_flash4";
			s_turret.str_tag_pivot = "tag_gunner_barrel4";
			break;
		}
	}
	if(isdefined(self.vehicleclass) && self.vehicleclass == "helicopter")
	{
		s_turret.e_trace_ignore = self;
	}
	if(!isdefined(self.a_turrets))
	{
		self.a_turrets = [];
	}
	self.a_turrets[n_index] = s_turret;
	if(n_index > 0)
	{
		tag_origin = self gettagorigin(_get_gunner_tag_for_turret_index(n_index));
		if(isdefined(tag_origin))
		{
			_set_turret_needs_user(n_index, 1);
		}
	}
	return s_turret;
}

/*
	Name: _burst_fire
	Namespace: turret
	Checksum: 0xCCEB02B9
	Offset: 0x4140
	Size: 0x20E
	Parameters: 2
	Flags: Linked
*/
function _burst_fire(n_max_time, n_index)
{
	self endon(#"terminate_all_turrets_firing");
	if(n_max_time < 0)
	{
		n_max_time = 9999;
	}
	s_turret = _get_turret_data(n_index);
	n_burst_time = _get_burst_fire_time(n_index);
	n_burst_wait = _get_burst_wait_time(n_index);
	if(!isdefined(n_burst_time) || n_burst_time > n_max_time)
	{
		n_burst_time = n_max_time;
	}
	if(s_turret.n_burst_fire_time >= n_burst_time)
	{
		s_turret.n_burst_fire_time = 0;
		n_time_since_last_shot = (gettime() - s_turret.n_last_fire_time) / 1000;
		if(n_time_since_last_shot < n_burst_wait)
		{
			wait(n_burst_wait - n_time_since_last_shot);
		}
	}
	else
	{
		n_burst_time = n_burst_time - s_turret.n_burst_fire_time;
	}
	w_weapon = get_weapon(n_index);
	n_fire_time = w_weapon.firetime;
	n_total_time = 0;
	while(n_total_time < n_burst_time)
	{
		fire(n_index);
		n_total_time = n_total_time + n_fire_time;
		s_turret.n_burst_fire_time = s_turret.n_burst_fire_time + n_fire_time;
		wait(n_fire_time);
	}
	if(n_burst_wait > 0)
	{
		wait(n_burst_wait);
	}
	return n_burst_time + n_burst_wait;
}

/*
	Name: _get_burst_fire_time
	Namespace: turret
	Checksum: 0x59C24CBC
	Offset: 0x4358
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function _get_burst_fire_time(n_index)
{
	s_turret = _get_turret_data(n_index);
	n_time = undefined;
	if(isdefined(s_turret.n_burst_fire_min) && isdefined(s_turret.n_burst_fire_max))
	{
		if(s_turret.n_burst_fire_min == s_turret.n_burst_fire_max)
		{
			n_time = s_turret.n_burst_fire_min;
		}
		else
		{
			n_time = randomfloatrange(s_turret.n_burst_fire_min, s_turret.n_burst_fire_max);
		}
	}
	else if(isdefined(s_turret.n_burst_fire_max))
	{
		n_time = randomfloatrange(0, s_turret.n_burst_fire_max);
	}
	return n_time;
}

/*
	Name: _get_burst_wait_time
	Namespace: turret
	Checksum: 0xE24B6AAE
	Offset: 0x4478
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function _get_burst_wait_time(n_index)
{
	s_turret = _get_turret_data(n_index);
	n_time = 0;
	if(isdefined(s_turret.n_burst_wait_min) && isdefined(s_turret.n_burst_wait_max))
	{
		if(s_turret.n_burst_wait_min == s_turret.n_burst_wait_max)
		{
			n_time = s_turret.n_burst_wait_min;
		}
		else
		{
			n_time = randomfloatrange(s_turret.n_burst_wait_min, s_turret.n_burst_wait_max);
		}
	}
	else if(isdefined(s_turret.n_burst_wait_max))
	{
		n_time = randomfloatrange(0, s_turret.n_burst_wait_max);
	}
	return n_time;
}

/*
	Name: _index
	Namespace: turret
	Checksum: 0xB48D38F3
	Offset: 0x4598
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function _index(n_index)
{
	return (isdefined(n_index) ? "" + n_index : "");
}

/*
	Name: _get_potential_targets
	Namespace: turret
	Checksum: 0x35CAFC62
	Offset: 0x45D0
	Size: 0x782
	Parameters: 1
	Flags: Linked
*/
function _get_potential_targets(n_index)
{
	s_turret = self _get_turret_data(n_index);
	a_priority_targets = self _get_any_priority_targets(n_index);
	if(isdefined(a_priority_targets) && a_priority_targets.size > 0)
	{
		return a_priority_targets;
	}
	a_potential_targets = [];
	str_team = get_team(n_index);
	if(self.use_non_teambased_enemy_selection === 1 && !level.teambased)
	{
		a_all_targets = [];
		if(_has_target_flags(1, n_index))
		{
			a_ai_targets = getaiarray();
			a_all_targets = arraycombine(a_all_targets, a_ai_targets, 1, 0);
		}
		if(_has_target_flags(2, n_index))
		{
			a_all_targets = arraycombine(a_all_targets, level.players, 1, 0);
		}
		if(_has_target_flags(8, n_index))
		{
			a_all_targets = arraycombine(a_all_targets, level.vehicles_list, 1, 0);
		}
		for(i = 0; i < a_all_targets.size; i++)
		{
			e_target = a_all_targets[i];
			if(!isdefined(e_target))
			{
				continue;
			}
			if(!isdefined(e_target.team))
			{
				continue;
			}
			if(e_target.team == str_team)
			{
				continue;
			}
			if(!(isdefined(level.team_free_targeting) && level.team_free_targeting) && e_target.team == "free")
			{
				continue;
			}
			a_potential_targets[a_potential_targets.size] = e_target;
		}
	}
	else if(isdefined(str_team))
	{
		str_opposite_team = "allies";
		if(str_team == "allies")
		{
			str_opposite_team = "axis";
		}
		if(_has_target_flags(1, n_index))
		{
			a_ai_targets = getaiteamarray(str_opposite_team);
			if(isdefined(level.team_free_targeting) && level.team_free_targeting)
			{
				a_ai_targets = arraycombine(getaiteamarray("free"), a_ai_targets, 1, 0);
			}
			a_potential_targets = arraycombine(a_potential_targets, a_ai_targets, 1, 0);
		}
		if(_has_target_flags(2, n_index))
		{
			a_potential_targets = arraycombine(a_potential_targets, level.aliveplayers[str_opposite_team], 1, 0);
		}
		if(_has_target_flags(8, n_index))
		{
			a_vehicle_targets = getvehicleteamarray(str_opposite_team);
			a_potential_targets = arraycombine(a_potential_targets, a_vehicle_targets, 1, 0);
		}
	}
	if(isdefined(s_turret.e_target) && !isinarray(a_potential_targets, s_turret.e_target))
	{
		a_potential_targets[a_potential_targets.size] = s_turret.e_target;
	}
	if(isdefined(str_team))
	{
		a_valid_targets = [];
		for(i = 0; i < a_potential_targets.size; i++)
		{
			e_target = a_potential_targets[i];
			ignore_target = 0;
			/#
				assert(isdefined(e_target), "");
			#/
			if(isdefined(e_target.ignoreme) && e_target.ignoreme || !isdefined(e_target.health) || e_target.health <= 0)
			{
				ignore_target = 1;
			}
			else
			{
				if(issentient(e_target) && (e_target isnotarget() || e_target ai::is_dead_sentient()))
				{
					ignore_target = 1;
				}
				else
				{
					if(_is_target_within_range(e_target, s_turret) == 0)
					{
						ignore_target = 1;
					}
					else if(isplayer(e_target) && e_target hasperk("specialty_nottargetedbysentry"))
					{
						ignore_target = 1;
					}
				}
			}
			if(!ignore_target)
			{
				a_valid_targets[a_valid_targets.size] = e_target;
			}
		}
		a_potential_targets = a_valid_targets;
	}
	a_targets = a_potential_targets;
	if(isdefined(s_turret) && isdefined(s_turret.a_ignore_target_array))
	{
		while(true)
		{
			found_bad_target = 0;
			a_targets = a_potential_targets;
			for(i = 0; i < a_targets.size; i++)
			{
				e_target = a_targets[i];
				found_bad_target = 0;
				for(j = 0; j < s_turret.a_ignore_target_array.size; j++)
				{
					if(e_target == s_turret.a_ignore_target_array[j])
					{
						arrayremovevalue(a_potential_targets, e_target);
						found_bad_target = 1;
						break;
					}
				}
			}
			if(!found_bad_target)
			{
				break;
			}
		}
	}
	return a_potential_targets;
}

/*
	Name: _is_target_within_range
	Namespace: turret
	Checksum: 0xBD2B8767
	Offset: 0x4D60
	Size: 0xFE
	Parameters: 2
	Flags: Linked
*/
function _is_target_within_range(e_target, s_turret)
{
	if(isdefined(s_turret.n_max_target_distance_squared) || isdefined(s_turret.n_min_target_distance_squared))
	{
		if(!isdefined(e_target.origin))
		{
			return false;
		}
		n_dist_squared = distancesquared(e_target.origin, self.origin);
		if(n_dist_squared > (isdefined(s_turret.n_max_target_distance_squared) ? s_turret.n_max_target_distance_squared : 811711611))
		{
			return false;
		}
		if(n_dist_squared < (isdefined(s_turret.n_min_target_distance_squared) ? s_turret.n_min_target_distance_squared : 0))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: _get_any_priority_targets
	Namespace: turret
	Checksum: 0x8B6F5BF7
	Offset: 0x4E68
	Size: 0x212
	Parameters: 1
	Flags: Linked
*/
function _get_any_priority_targets(n_index)
{
	a_targets = undefined;
	s_turret = _get_turret_data(n_index);
	if(isdefined(s_turret.priority_target_array))
	{
		while(true)
		{
			found_bad_target = 0;
			a_targets = s_turret.priority_target_array;
			for(i = 0; i < a_targets.size; i++)
			{
				e_target = a_targets[i];
				bad_index = undefined;
				if(!isdefined(e_target))
				{
					bad_index = i;
				}
				else
				{
					if(!isalive(e_target))
					{
						bad_index = i;
					}
					else
					{
						if(e_target.health <= 0)
						{
							bad_index = i;
						}
						else if(issentient(e_target) && e_target ai::is_dead_sentient())
						{
							bad_index = i;
						}
					}
				}
				if(isdefined(bad_index))
				{
					s_turret.priority_target_array = a_targets;
					arrayremovevalue(s_turret.priority_target_array, e_target);
					found_bad_target = 1;
					break;
				}
			}
			if(!found_bad_target)
			{
				return s_turret.priority_target_array;
			}
			if(s_turret.priority_target_array.size <= 0)
			{
				s_turret.priority_target_array = undefined;
				self notify(#"target_array_destroyed");
				break;
			}
		}
	}
	return a_targets;
}

/*
	Name: _get_best_target_from_potential
	Namespace: turret
	Checksum: 0x6C2EE699
	Offset: 0x5088
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function _get_best_target_from_potential(a_potential_targets, n_index)
{
	s_turret = _get_turret_data(n_index);
	return [[s_turret.func_get_best_target]](a_potential_targets, n_index);
}

/*
	Name: _get_best_target_bullet
	Namespace: turret
	Checksum: 0xC52C488C
	Offset: 0x50E8
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function _get_best_target_bullet(a_potential_targets, n_index)
{
	e_best_target = undefined;
	while(!isdefined(e_best_target) && a_potential_targets.size > 0)
	{
		e_closest_target = arraygetclosest(self.origin, a_potential_targets);
		if(!isdefined(e_closest_target))
		{
			break;
		}
		else
		{
			if(self can_hit_target(e_closest_target, n_index))
			{
				e_best_target = e_closest_target;
			}
			else
			{
				arrayremovevalue(a_potential_targets, e_closest_target);
			}
		}
	}
	return e_best_target;
}

/*
	Name: _get_best_target_gas
	Namespace: turret
	Checksum: 0xCAEF113F
	Offset: 0x51B8
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function _get_best_target_gas(a_potential_targets, n_index)
{
	return _get_best_target_bullet(a_potential_targets, n_index);
}

/*
	Name: _get_best_target_grenade
	Namespace: turret
	Checksum: 0x660CC1EC
	Offset: 0x51F0
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function _get_best_target_grenade(a_potential_targets, n_index)
{
	return _get_best_target_bullet(a_potential_targets, n_index);
}

/*
	Name: _get_best_target_projectile
	Namespace: turret
	Checksum: 0x4BE5D7CE
	Offset: 0x5228
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function _get_best_target_projectile(a_potential_targets, n_index)
{
	return _get_best_target_bullet(a_potential_targets, n_index);
}

/*
	Name: can_hit_target
	Namespace: turret
	Checksum: 0xE7C401CA
	Offset: 0x5260
	Size: 0x22C
	Parameters: 2
	Flags: Linked
*/
function can_hit_target(e_target, n_index)
{
	s_turret = _get_turret_data(n_index);
	v_offset = _get_default_target_offset(e_target, n_index);
	b_current_target = is_target(e_target, n_index);
	if(isdefined(e_target) && (isdefined(e_target.ignoreme) && e_target.ignoreme))
	{
		return 0;
	}
	b_target_in_view = is_target_in_view((isplayer(e_target) ? e_target gettagorigin("tag_eye") : e_target.origin + v_offset), n_index);
	b_trace_passed = 1;
	if(b_target_in_view)
	{
		if(!s_turret.b_ignore_line_of_sight)
		{
			b_trace_passed = trace_test(e_target, v_offset - (0, 0, (isvehicle(e_target) ? 0 : (isdefined(s_turret.n_torso_targetting_offset) ? s_turret.n_torso_targetting_offset : 0))), n_index);
		}
		if(b_current_target && !b_trace_passed && !isdefined(s_turret.n_time_lose_sight))
		{
			s_turret.n_time_lose_sight = gettime();
		}
	}
	else if(b_current_target)
	{
		s_turret.b_target_out_of_range = 1;
	}
	return b_target_in_view && b_trace_passed;
}

/*
	Name: is_target_in_view
	Namespace: turret
	Checksum: 0x389EE6BC
	Offset: 0x5498
	Size: 0x234
	Parameters: 2
	Flags: Linked
*/
function is_target_in_view(v_target, n_index)
{
	/#
		_update_turret_arcs(n_index);
	#/
	s_turret = _get_turret_data(n_index);
	v_pivot_pos = self gettagorigin(s_turret.str_tag_pivot);
	v_angles_to_target = vectortoangles(v_target - v_pivot_pos);
	n_rest_angle_pitch = s_turret.n_rest_angle_pitch + self.angles[0];
	n_rest_angle_yaw = s_turret.n_rest_angle_yaw + self.angles[1];
	n_ang_pitch = angleclamp180(v_angles_to_target[0] - n_rest_angle_pitch);
	n_ang_yaw = angleclamp180(v_angles_to_target[1] - n_rest_angle_yaw);
	b_out_of_range = 0;
	if(n_ang_pitch > 0)
	{
		if(n_ang_pitch > s_turret.bottomarc)
		{
			b_out_of_range = 1;
		}
	}
	else if(abs(n_ang_pitch) > s_turret.toparc)
	{
		b_out_of_range = 1;
	}
	if(n_ang_yaw > 0)
	{
		if(n_ang_yaw > s_turret.leftarc)
		{
			b_out_of_range = 1;
		}
	}
	else if(abs(n_ang_yaw) > s_turret.rightarc)
	{
		b_out_of_range = 1;
	}
	return !b_out_of_range;
}

/*
	Name: trace_test
	Namespace: turret
	Checksum: 0x9E7A2957
	Offset: 0x56D8
	Size: 0x2CE
	Parameters: 3
	Flags: Linked
*/
function trace_test(e_target, v_offset = (0, 0, 0), n_index)
{
	if(isdefined(self.good_old_style_turret_tracing))
	{
		s_turret = _get_turret_data(n_index);
		v_start_org = self gettagorigin(s_turret.str_tag_pivot);
		if(e_target sightconetrace(v_start_org, self) > 0.2)
		{
			v_target = e_target.origin + v_offset;
			v_start_org = v_start_org + ((vectornormalize(v_target - v_start_org)) * 50);
			a_trace = bullettrace(v_start_org, v_target, 1, s_turret.e_trace_ignore, 1, 1);
			if(a_trace["fraction"] > 0.6)
			{
				return true;
			}
		}
		return false;
	}
	s_turret = _get_turret_data(n_index);
	v_start_org = self gettagorigin(s_turret.str_tag_pivot);
	v_target = e_target.origin + v_offset;
	if(sessionmodeismultiplayergame() && isplayer(e_target))
	{
		v_target = e_target getshootatpos();
	}
	if(distancesquared(v_start_org, v_target) < 10000)
	{
		return true;
	}
	v_dir_to_target = vectornormalize(v_target - v_start_org);
	if(!sessionmodeismultiplayergame())
	{
		v_start_org = v_start_org + (v_dir_to_target * 50);
		v_target = v_target - (v_dir_to_target * 75);
	}
	if(sighttracepassed(v_start_org, v_target, 0, self))
	{
		return true;
	}
	return false;
}

/*
	Name: set_ignore_line_of_sight
	Namespace: turret
	Checksum: 0x6BDE41D3
	Offset: 0x59B0
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function set_ignore_line_of_sight(b_ignore, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.b_ignore_line_of_sight = b_ignore;
}

/*
	Name: set_occupy_no_target_time
	Namespace: turret
	Checksum: 0x36AC5A1C
	Offset: 0x5A08
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function set_occupy_no_target_time(time, n_index)
{
	s_turret = _get_turret_data(n_index);
	s_turret.occupy_no_target_time = time;
}

/*
	Name: toggle_lensflare
	Namespace: turret
	Checksum: 0x26E31ABC
	Offset: 0x5A60
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function toggle_lensflare(bool)
{
	self clientfield::set("toggle_lensflare", bool);
}

/*
	Name: track_lens_flare
	Namespace: turret
	Checksum: 0x3AC4DF0A
	Offset: 0x5A98
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function track_lens_flare()
{
	self endon(#"death");
	self notify(#"disable_lens_flare");
	self endon(#"disable_lens_flare");
	while(true)
	{
		e_target = self gettargetentity();
		if(self.turretontarget && (isdefined(e_target) && isplayer(e_target)))
		{
			if(isdefined(self gettagorigin("TAG_LASER")))
			{
				e_target util::waittill_player_looking_at(self gettagorigin("TAG_LASER"), 90);
				if(isdefined(e_target))
				{
					self toggle_lensflare(1);
					e_target util::waittill_player_not_looking_at(self gettagorigin("TAG_LASER"));
				}
				self toggle_lensflare(0);
			}
		}
		wait(0.5);
	}
}

/*
	Name: _get_gunner_tag_for_turret_index
	Namespace: turret
	Checksum: 0x816EB9E0
	Offset: 0x5BF0
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function _get_gunner_tag_for_turret_index(n_index)
{
	switch(n_index)
	{
		case 1:
		{
			return "tag_gunner1";
		}
		case 2:
		{
			return "tag_gunner2";
		}
		case 3:
		{
			return "tag_gunner3";
		}
		case 4:
		{
			return "tag_gunner4";
		}
		default:
		{
			/#
				assertmsg("");
			#/
		}
	}
}

/*
	Name: _get_turret_index_for_tag
	Namespace: turret
	Checksum: 0xBE0D6453
	Offset: 0x5C80
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function _get_turret_index_for_tag(str_tag)
{
	switch(str_tag)
	{
		case "tag_gunner1":
		{
			return 1;
		}
		case "tag_gunner2":
		{
			return 2;
		}
		case "tag_gunner3":
		{
			return 3;
		}
		case "tag_gunner4":
		{
			return 4;
		}
	}
}

