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

#namespace replay_gun;

/*
	Name: __init__sytem__
	Namespace: replay_gun
	Checksum: 0xE680F5DB
	Offset: 0x1D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("replay_gun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: replay_gun
	Checksum: 0x8AE866DD
	Offset: 0x210
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_spawned(&watch_for_replay_gun);
}

/*
	Name: watch_for_replay_gun
	Namespace: replay_gun
	Checksum: 0xDD7341A9
	Offset: 0x240
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function watch_for_replay_gun()
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"spawned_player");
	self endon(#"killreplaygunmonitor");
	while(true)
	{
		self waittill(#"weapon_change_complete", weapon);
		self weaponlockfree();
		if(isdefined(weapon.usespivottargeting) && weapon.usespivottargeting)
		{
			self thread watch_lockon(weapon);
		}
	}
}

/*
	Name: watch_lockon
	Namespace: replay_gun
	Checksum: 0x7B092F85
	Offset: 0x2F8
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function watch_lockon(weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"spawned_player");
	self endon(#"weapon_change_complete");
	while(true)
	{
		wait(0.05);
		if(!isdefined(self.lockonentity))
		{
			ads = self playerads() == 1;
			if(ads)
			{
				target = self get_a_target(weapon);
				if(is_valid_target(target))
				{
					self weaponlockfree();
					self.lockonentity = target;
				}
			}
		}
	}
}

/*
	Name: get_a_target
	Namespace: replay_gun
	Checksum: 0x411A8683
	Offset: 0x3F0
	Size: 0x2EA
	Parameters: 1
	Flags: Linked
*/
function get_a_target(weapon)
{
	origin = self getweaponmuzzlepoint();
	forward = self getweaponforwarddir();
	targets = self get_potential_targets();
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
	for(i = 0; i < targets.size; i++)
	{
		if(should_wait)
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
		if(!self inside_screen_crosshair_radius(testorigin, weapon))
		{
			continue;
		}
		cansee = self can_see_projected_crosshair(testtarget, testorigin, origin, forward, test_range);
		should_wait = 1;
		if(cansee)
		{
			validtargets[validtargets.size] = testtarget;
		}
	}
	return pick_a_target_from(validtargets);
}

/*
	Name: get_potential_targets
	Namespace: replay_gun
	Checksum: 0xEF543EE7
	Offset: 0x6E8
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function get_potential_targets()
{
	str_opposite_team = "axis";
	if(self.team == "axis")
	{
		str_opposite_team = "allies";
	}
	potentialtargets = [];
	aitargets = getaiteamarray(str_opposite_team);
	if(aitargets.size > 0)
	{
		potentialtargets = arraycombine(potentialtargets, aitargets, 1, 0);
	}
	playertargets = self getenemies();
	if(playertargets.size > 0)
	{
		potentialtargets = arraycombine(potentialtargets, playertargets, 1, 0);
	}
	if(potentialtargets.size == 0)
	{
		return undefined;
	}
	return potentialtargets;
}

/*
	Name: pick_a_target_from
	Namespace: replay_gun
	Checksum: 0x3E45CF2B
	Offset: 0x7F0
	Size: 0x120
	Parameters: 1
	Flags: Linked
*/
function pick_a_target_from(targets)
{
	if(!isdefined(targets))
	{
		return undefined;
	}
	besttarget = undefined;
	besttargetdistancesquared = undefined;
	for(i = 0; i < targets.size; i++)
	{
		target = targets[i];
		if(is_valid_target(target))
		{
			targetdistancesquared = distancesquared(self.origin, target.origin);
			if(!isdefined(besttarget) || !isdefined(besttargetdistancesquared))
			{
				besttarget = target;
				besttargetdistancesquared = targetdistancesquared;
				continue;
			}
			if(targetdistancesquared < besttargetdistancesquared)
			{
				besttarget = target;
				besttargetdistancesquared = targetdistancesquared;
			}
		}
	}
	return besttarget;
}

/*
	Name: trace
	Namespace: replay_gun
	Checksum: 0xDE141C1C
	Offset: 0x918
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function trace(from, to)
{
	return bullettrace(from, to, 0, self)["position"];
}

/*
	Name: can_see_projected_crosshair
	Namespace: replay_gun
	Checksum: 0x99EBE69D
	Offset: 0x960
	Size: 0xEC
	Parameters: 5
	Flags: Linked
*/
function can_see_projected_crosshair(target, target_origin, player_origin, player_forward, distance)
{
	crosshair = player_origin + (player_forward * distance);
	collided = target trace(target_origin, crosshair);
	if(distance2dsquared(crosshair, collided) > 9)
	{
		return false;
	}
	collided = self trace(player_origin, crosshair);
	if(distance2dsquared(crosshair, collided) > 9)
	{
		return false;
	}
	return true;
}

/*
	Name: is_valid_target
	Namespace: replay_gun
	Checksum: 0xE3D519D4
	Offset: 0xA58
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function is_valid_target(ent)
{
	return isdefined(ent) && isalive(ent);
}

/*
	Name: inside_screen_crosshair_radius
	Namespace: replay_gun
	Checksum: 0x2857B355
	Offset: 0xA90
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function inside_screen_crosshair_radius(testorigin, weapon)
{
	radius = weapon.lockonscreenradius;
	return self inside_screen_radius(testorigin, radius);
}

/*
	Name: inside_screen_lockon_radius
	Namespace: replay_gun
	Checksum: 0xC419F5BE
	Offset: 0xAE8
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
	Namespace: replay_gun
	Checksum: 0x3321CBA0
	Offset: 0xB40
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
	Namespace: replay_gun
	Checksum: 0xDA063C6E
	Offset: 0xB88
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function get_target_lock_on_origin(target)
{
	return self getreplaygunlockonorigin(target);
}

