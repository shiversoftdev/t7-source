// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace grapple;

/*
	Name: __init__sytem__
	Namespace: grapple
	Checksum: 0x5F7CF6D5
	Offset: 0x248
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("grapple", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: grapple
	Checksum: 0xD8107BE
	Offset: 0x290
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_spawned(&watch_for_grapple);
}

/*
	Name: __main__
	Namespace: grapple
	Checksum: 0x2FAFD7A3
	Offset: 0x2C0
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	grapple_targets = getentarray("grapple_target", "targetname");
	foreach(target in grapple_targets)
	{
		target.grapple_type = 1;
		target setgrapplabletype(target.grapple_type);
	}
}

/*
	Name: translate_notify_1
	Namespace: grapple
	Checksum: 0x9CFDDFE
	Offset: 0x3A0
	Size: 0x8A
	Parameters: 2
	Flags: Linked
*/
function translate_notify_1(from_notify, to_notify)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"spawned_player");
	while(isdefined(self))
	{
		self waittill(from_notify, param1, param2, param3);
		self notify(to_notify, from_notify, param1, param2, param3);
	}
}

/*
	Name: watch_for_grapple
	Namespace: grapple
	Checksum: 0xB9EDC697
	Offset: 0x438
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function watch_for_grapple()
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"spawned_player");
	self endon(#"killreplaygunmonitor");
	self thread translate_notify_1("weapon_switch_started", "grapple_weapon_change");
	self thread translate_notify_1("weapon_change_complete", "grapple_weapon_change");
	while(true)
	{
		self waittill(#"grapple_weapon_change", event, weapon);
		if(isdefined(weapon.grappleweapon) && weapon.grappleweapon)
		{
			self thread watch_lockon(weapon);
		}
		else
		{
			self notify(#"grapple_unwield");
		}
	}
}

/*
	Name: watch_lockon
	Namespace: grapple
	Checksum: 0x6FB44EAD
	Offset: 0x540
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function watch_lockon(weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"spawned_player");
	self endon(#"grapple_unwield");
	self notify(#"watch_lockon");
	self endon(#"watch_lockon");
	self thread watch_lockon_angles(weapon);
	self thread clear_lockon_after_grapple(weapon);
	self.use_expensive_targeting = 1;
	while(true)
	{
		wait(0.05);
		if(!self isgrappling())
		{
			target = self get_a_target(weapon);
			if(!self isgrappling() && !target === self.lockonentity)
			{
				self weaponlocknoclearance(!target === self.dummy_target);
				self.lockonentity = target;
				wait(0.1);
			}
		}
	}
}

/*
	Name: clear_lockon_after_grapple
	Namespace: grapple
	Checksum: 0xC1854E2F
	Offset: 0x688
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function clear_lockon_after_grapple(weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"spawned_player");
	self endon(#"grapple_unwield");
	self notify(#"clear_lockon_after_grapple");
	self endon(#"clear_lockon_after_grapple");
	while(true)
	{
		self util::waittill_any("grapple_pulled", "grapple_landed");
		if(isdefined(self.lockonentity))
		{
			self.lockonentity = undefined;
			self.use_expensive_targeting = 1;
		}
	}
}

/*
	Name: watch_lockon_angles
	Namespace: grapple
	Checksum: 0x614C00DF
	Offset: 0x738
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function watch_lockon_angles(weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"spawned_player");
	self endon(#"grapple_unwield");
	self notify(#"watch_lockon_angles");
	self endon(#"watch_lockon_angles");
	while(true)
	{
		wait(0.05);
		if(!self isgrappling())
		{
			if(isdefined(self.lockonentity))
			{
				if(self.lockonentity === self.dummy_target)
				{
					self weaponlocktargettooclose(0);
				}
				else
				{
					testorigin = get_target_lock_on_origin(self.lockonentity);
					if(!self inside_screen_angles(testorigin, weapon, 0))
					{
						self weaponlocktargettooclose(1);
					}
					else
					{
						self weaponlocktargettooclose(0);
					}
				}
			}
		}
	}
}

/*
	Name: place_dummy_target
	Namespace: grapple
	Checksum: 0xC3F53AC0
	Offset: 0x870
	Size: 0x186
	Parameters: 3
	Flags: Linked
*/
function place_dummy_target(origin, forward, weapon)
{
	if(!isdefined(self.dummy_target))
	{
		self.dummy_target = spawn("script_origin", origin);
	}
	self.dummy_target setgrapplabletype(3);
	start = origin;
	distance = weapon.lockonmaxrange * 0.9;
	if(isdefined(level.grapple_notarget_distance))
	{
		distance = level.grapple_notarget_distance;
	}
	end = origin + (forward * distance);
	if(!self isgrappling())
	{
		self.dummy_target.origin = self trace(start, end, self.dummy_target);
	}
	minrange_sq = weapon.lockonminrange * weapon.lockonminrange;
	if(distancesquared(self.dummy_target.origin, origin) < minrange_sq)
	{
		return undefined;
	}
	return self.dummy_target;
}

/*
	Name: get_a_target
	Namespace: grapple
	Checksum: 0xB795839B
	Offset: 0xA00
	Size: 0x3CC
	Parameters: 1
	Flags: Linked
*/
function get_a_target(weapon)
{
	origin = self geteye();
	forward = self getweaponforwarddir();
	targets = getgrappletargetarray();
	if(!isdefined(targets))
	{
		return undefined;
	}
	if(!isdefined(weapon.lockonscreenradius) || weapon.lockonscreenradius < 1)
	{
		return undefined;
	}
	validtargets = [];
	should_wait = 0;
	should_wait_limit = 2;
	if(isdefined(self.use_expensive_targeting) && self.use_expensive_targeting)
	{
		should_wait_limit = 4;
		self.use_expensive_targeting = 0;
	}
	for(i = 0; i < targets.size; i++)
	{
		if(should_wait >= should_wait_limit)
		{
			wait(0.05);
			origin = self getweaponmuzzlepoint();
			forward = self getweaponforwarddir();
			should_wait = 0;
		}
		testtarget = targets[i];
		if(!is_valid_target(testtarget))
		{
			continue;
		}
		testorigin = get_target_lock_on_origin(testtarget);
		test_range = distance(origin, testorigin);
		if(test_range > weapon.lockonmaxrange || test_range < weapon.lockonminrange)
		{
			continue;
		}
		normal = vectornormalize(testorigin - origin);
		dot = vectordot(forward, normal);
		if(0 > dot)
		{
			continue;
		}
		if(!self inside_screen_angles(testorigin, weapon, !testtarget === self.lockonentity))
		{
			continue;
		}
		cansee = self can_see(testtarget, testorigin, origin, forward, 30);
		should_wait++;
		if(cansee)
		{
			validtargets[validtargets.size] = testtarget;
		}
	}
	best = pick_a_target_from(validtargets, origin, forward, weapon.lockonminrange, weapon.lockonmaxrange);
	if(isdefined(level.grapple_notarget_enabled) && level.grapple_notarget_enabled)
	{
		if(!isdefined(best) || best === self.dummy_target)
		{
			best = place_dummy_target(origin, forward, weapon);
		}
	}
	return best;
}

/*
	Name: get_target_type_score
	Namespace: grapple
	Checksum: 0x8CAA6854
	Offset: 0xDD8
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function get_target_type_score(target)
{
	if(!isdefined(target))
	{
		return 0;
	}
	if(target === self.dummy_target)
	{
		return 0;
	}
	if(target.grapple_type === 1)
	{
		return 1;
	}
	if(target.grapple_type === 2)
	{
		return 0.985;
	}
	if(!isdefined(target.grapple_type))
	{
		return 0.9;
	}
	if(target.grapple_type === 3)
	{
		return 0.75;
	}
	return 0;
}

/*
	Name: get_target_score
	Namespace: grapple
	Checksum: 0xD1C3B9C
	Offset: 0xE90
	Size: 0x19A
	Parameters: 5
	Flags: Linked
*/
function get_target_score(target, origin, forward, min_range, max_range)
{
	if(!isdefined(target))
	{
		return -1;
	}
	if(target === self.dummy_target)
	{
		return 0;
	}
	if(is_valid_target(target))
	{
		testorigin = get_target_lock_on_origin(target);
		normal = vectornormalize(testorigin - origin);
		dot = vectordot(forward, normal);
		targetdistance = distance(self.origin, testorigin);
		distance_score = 1 - (targetdistance - min_range) / (max_range - min_range);
		type_score = get_target_type_score(target);
		return (type_score * pow(dot, 0.85)) * pow(distance_score, 0.15);
	}
	return -1;
}

/*
	Name: pick_a_target_from
	Namespace: grapple
	Checksum: 0x86DBDECB
	Offset: 0x1038
	Size: 0x140
	Parameters: 5
	Flags: Linked
*/
function pick_a_target_from(targets, origin, forward, min_range, max_range)
{
	if(!isdefined(targets))
	{
		return undefined;
	}
	besttarget = undefined;
	bestscore = undefined;
	for(i = 0; i < targets.size; i++)
	{
		target = targets[i];
		if(is_valid_target(target))
		{
			score = get_target_score(target, origin, forward, min_range, max_range);
			if(!isdefined(besttarget) || !isdefined(bestscore))
			{
				besttarget = target;
				bestscore = score;
				continue;
			}
			if(score > bestscore)
			{
				besttarget = target;
				bestscore = score;
			}
		}
	}
	return besttarget;
}

/*
	Name: trace
	Namespace: grapple
	Checksum: 0x1AEBF85A
	Offset: 0x1180
	Size: 0x5C
	Parameters: 3
	Flags: Linked
*/
function trace(from, to, target)
{
	trace = bullettrace(from, to, 0, self, 1, 0, target);
	return trace["position"];
}

/*
	Name: can_see
	Namespace: grapple
	Checksum: 0x2FE8A7C0
	Offset: 0x11E8
	Size: 0x178
	Parameters: 5
	Flags: Linked
*/
function can_see(target, target_origin, player_origin, player_forward, distance)
{
	start = player_origin + (player_forward * distance);
	end = target_origin - (player_forward * distance);
	collided = self trace(start, end, target);
	if(distance2dsquared(end, collided) > 9)
	{
		/#
			if(getdvarint(""))
			{
				line(start, collided, (0, 0, 1), 1, 0, 50);
				line(collided, end, (1, 0, 0), 1, 0, 50);
			}
		#/
		return false;
	}
	/#
		if(getdvarint(""))
		{
			line(start, end, (0, 1, 0), 1, 0, 30);
		}
	#/
	return true;
}

/*
	Name: is_valid_target
	Namespace: grapple
	Checksum: 0x63620F01
	Offset: 0x1368
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function is_valid_target(ent)
{
	if(isdefined(ent) && isdefined(level.grapple_valid_target_check))
	{
		if(![[level.grapple_valid_target_check]](ent))
		{
			return 0;
		}
	}
	return isdefined(ent) && (isalive(ent) || !issentient(ent));
}

/*
	Name: inside_screen_angles
	Namespace: grapple
	Checksum: 0x15DEAB00
	Offset: 0x13E8
	Size: 0xF8
	Parameters: 3
	Flags: Linked
*/
function inside_screen_angles(testorigin, weapon, newtarget)
{
	hang = weapon.lockonlossanglehorizontal;
	if(newtarget)
	{
		hang = weapon.lockonanglehorizontal;
	}
	vang = weapon.lockonlossanglevertical;
	if(newtarget)
	{
		vang = weapon.lockonanglevertical;
	}
	angles = self gettargetscreenangles(testorigin);
	return abs(angles[0]) < hang && abs(angles[1]) < vang;
}

/*
	Name: inside_screen_crosshair_radius
	Namespace: grapple
	Checksum: 0xEF02A434
	Offset: 0x14E8
	Size: 0x4A
	Parameters: 2
	Flags: None
*/
function inside_screen_crosshair_radius(testorigin, weapon)
{
	radius = weapon.lockonscreenradius;
	return self inside_screen_radius(testorigin, radius);
}

/*
	Name: inside_screen_lockon_radius
	Namespace: grapple
	Checksum: 0x3F7329BE
	Offset: 0x1540
	Size: 0x4A
	Parameters: 1
	Flags: None
*/
function inside_screen_lockon_radius(targetorigin)
{
	radius = self getlockonradius();
	return self inside_screen_radius(targetorigin, radius);
}

/*
	Name: inside_screen_radius
	Namespace: grapple
	Checksum: 0x3759731A
	Offset: 0x1598
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function inside_screen_radius(targetorigin, radius)
{
	return target_originisincircle(targetorigin, self, 65, radius);
}

/*
	Name: get_target_lock_on_origin
	Namespace: grapple
	Checksum: 0x36EF5584
	Offset: 0x15E0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function get_target_lock_on_origin(target)
{
	return self getlockonorigin(target);
}

