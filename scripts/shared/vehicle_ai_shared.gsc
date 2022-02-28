// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace vehicle_ai;

/*
	Name: __init__sytem__
	Namespace: vehicle_ai
	Checksum: 0x22A80DD0
	Offset: 0x488
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle_ai", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle_ai
	Checksum: 0x99EC1590
	Offset: 0x4C8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: registersharedinterfaceattributes
	Namespace: vehicle_ai
	Checksum: 0xC63DF162
	Offset: 0x4D8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function registersharedinterfaceattributes(archetype)
{
	ai::registermatchedinterface(archetype, "force_high_speed", 0, array(1, 0));
}

/*
	Name: initthreatbias
	Namespace: vehicle_ai
	Checksum: 0x2BC4137E
	Offset: 0x520
	Size: 0x122
	Parameters: 0
	Flags: Linked
*/
function initthreatbias()
{
	aiarray = getaiarray();
	foreach(ai in aiarray)
	{
		if(ai === self)
		{
			continue;
		}
		if(self.ignorefirefly === 1 && ai.firefly === 1)
		{
			self setpersonalignore(ai);
		}
		if(self.ignoredecoy === 1 && ai.var_e42818a3 === 1)
		{
			self setpersonalignore(ai);
		}
	}
}

/*
	Name: entityisarchetype
	Namespace: vehicle_ai
	Checksum: 0xF05386D0
	Offset: 0x650
	Size: 0xBC
	Parameters: 2
	Flags: None
*/
function entityisarchetype(entity, archetype)
{
	if(!isdefined(entity))
	{
		return false;
	}
	if(isplayer(entity) && entity.usingvehicle && isdefined(entity.viewlockedentity) && entity.viewlockedentity.archetype === archetype)
	{
		return true;
	}
	if(isvehicle(entity) && entity.archetype === archetype)
	{
		return true;
	}
	return false;
}

/*
	Name: getenemytarget
	Namespace: vehicle_ai
	Checksum: 0xBC86BBE7
	Offset: 0x718
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function getenemytarget()
{
	if(isdefined(self.enemy) && self vehcansee(self.enemy))
	{
		return self.enemy;
	}
	if(isdefined(self.enemylastseenpos))
	{
		return self.enemylastseenpos;
	}
	return undefined;
}

/*
	Name: gettargetpos
	Namespace: vehicle_ai
	Checksum: 0x84CD94CD
	Offset: 0x778
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function gettargetpos(target, geteye)
{
	pos = undefined;
	if(isdefined(target))
	{
		if(isvec(target))
		{
			pos = target;
		}
		else
		{
			if(isdefined(geteye) && geteye && issentient(target))
			{
				pos = target geteye();
			}
			else
			{
				if(isentity(target))
				{
					pos = target.origin;
				}
				else if(isdefined(target.origin) && isvec(target.origin))
				{
					pos = target.origin;
				}
			}
		}
	}
	return pos;
}

/*
	Name: gettargeteyeoffset
	Namespace: vehicle_ai
	Checksum: 0xB111546E
	Offset: 0x898
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function gettargeteyeoffset(target)
{
	offset = (0, 0, 0);
	if(isdefined(target) && issentient(target))
	{
		offset = target geteye() - target.origin;
	}
	return offset;
}

/*
	Name: fire_for_time
	Namespace: vehicle_ai
	Checksum: 0x2F425E0E
	Offset: 0x910
	Size: 0x174
	Parameters: 4
	Flags: Linked
*/
function fire_for_time(totalfiretime, turretidx = 0, target, intervalscale = 1)
{
	self endon(#"death");
	self endon(#"change_state");
	self notify(#"fire_stop");
	self endon(#"fire_stop");
	weapon = self seatgetweapon(turretidx);
	/#
		assert(isdefined(weapon) && weapon.name != "" && weapon.firetime > 0);
	#/
	firetime = weapon.firetime * intervalscale;
	firecount = (int(floor(totalfiretime / firetime))) + 1;
	__fire_for_rounds_internal(firecount, firetime, turretidx, target);
}

/*
	Name: fire_for_rounds
	Namespace: vehicle_ai
	Checksum: 0xA4FCCB6E
	Offset: 0xA90
	Size: 0xEC
	Parameters: 3
	Flags: Linked
*/
function fire_for_rounds(firecount, turretidx, target)
{
	self endon(#"death");
	self endon(#"fire_stop");
	self endon(#"change_state");
	if(!isdefined(turretidx))
	{
		turretidx = 0;
	}
	weapon = self seatgetweapon(turretidx);
	/#
		assert(isdefined(weapon) && weapon.name != "" && weapon.firetime > 0);
	#/
	__fire_for_rounds_internal(firecount, weapon.firetime, turretidx, target);
}

/*
	Name: __fire_for_rounds_internal
	Namespace: vehicle_ai
	Checksum: 0x62DD2D6C
	Offset: 0xB88
	Size: 0x21C
	Parameters: 4
	Flags: Linked
*/
function __fire_for_rounds_internal(firecount, fireinterval, turretidx, target)
{
	self endon(#"death");
	self endon(#"fire_stop");
	self endon(#"change_state");
	if(isdefined(target) && issentient(target))
	{
		target endon(#"death");
	}
	/#
		assert(isdefined(turretidx));
	#/
	aifirechance = 1;
	if(isdefined(target) && !isplayer(target) && isai(target) || isdefined(self.fire_half_blanks))
	{
		aifirechance = 2;
	}
	counter = 0;
	while(counter < firecount)
	{
		if(self.avoid_shooting_owner === 1 && self owner_in_line_of_fire())
		{
			wait(fireinterval);
			continue;
		}
		if(isdefined(target) && !isvec(target) && isdefined(target.attackeraccuracy) && target.attackeraccuracy == 0)
		{
			self fireturret(turretidx, 1);
		}
		else
		{
			if(aifirechance > 1)
			{
				self fireturret(turretidx, counter % aifirechance);
			}
			else
			{
				self fireturret(turretidx);
			}
		}
		counter++;
		wait(fireinterval);
	}
}

/*
	Name: owner_in_line_of_fire
	Namespace: vehicle_ai
	Checksum: 0x41604A55
	Offset: 0xDB0
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function owner_in_line_of_fire()
{
	if(!isdefined(self.owner))
	{
		return 0;
	}
	dist_squared_to_owner = distancesquared(self.owner.origin, self.origin);
	line_of_fire_dot = (dist_squared_to_owner < 9216 ? 0.866 : 0.9848);
	gun_angles = self gettagangles((isdefined(self.avoid_shooting_owner_ref_tag) ? self.avoid_shooting_owner_ref_tag : "tag_flash"));
	gun_forward = anglestoforward(gun_angles);
	dot = vectordot(gun_forward, vectornormalize(self.owner.origin - self.origin));
	return dot > line_of_fire_dot;
}

/*
	Name: setturrettarget
	Namespace: vehicle_ai
	Checksum: 0xDB976140
	Offset: 0xEE8
	Size: 0x14C
	Parameters: 3
	Flags: None
*/
function setturrettarget(target, turretidx = 0, offset = (0, 0, 0))
{
	if(isentity(target))
	{
		if(turretidx == 0)
		{
			self setturrettargetent(target, offset);
		}
		else
		{
			self setgunnertargetent(target, offset, turretidx - 1);
		}
	}
	else
	{
		if(isvec(target))
		{
			origin = target + offset;
			if(turretidx == 0)
			{
				self setturrettargetvec(target);
			}
			else
			{
				self setgunnertargetvec(target, turretidx - 1);
			}
		}
		else
		{
			/#
				assertmsg("");
			#/
		}
	}
}

/*
	Name: fireturret
	Namespace: vehicle_ai
	Checksum: 0x27DEB27D
	Offset: 0x1040
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function fireturret(turretidx, isfake)
{
	self fireweapon(turretidx, undefined, undefined, self);
}

/*
	Name: javelin_losetargetatrighttime
	Namespace: vehicle_ai
	Checksum: 0x695829D9
	Offset: 0x1080
	Size: 0xE4
	Parameters: 1
	Flags: None
*/
function javelin_losetargetatrighttime(target)
{
	self endon(#"death");
	self waittill(#"weapon_fired", proj);
	if(!isdefined(proj))
	{
		return;
	}
	proj endon(#"death");
	wait(2);
	while(isdefined(target))
	{
		if(proj getvelocity()[2] < -150 && distancesquared(proj.origin, target.origin) < (1200 * 1200))
		{
			proj missile_settarget(undefined);
			break;
		}
		wait(0.1);
	}
}

/*
	Name: waittill_pathing_done
	Namespace: vehicle_ai
	Checksum: 0xD130444C
	Offset: 0x1170
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function waittill_pathing_done(maxtime = 15)
{
	self endon(#"change_state");
	self util::waittill_any_ex(maxtime, "near_goal", "force_goal", "reached_end_node", "goal", "pathfind_failed", "change_state");
}

/*
	Name: waittill_pathresult
	Namespace: vehicle_ai
	Checksum: 0x2F53DE23
	Offset: 0x11F0
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function waittill_pathresult(maxtime = 0.5)
{
	self endon(#"change_state");
	result = self util::waittill_any_timeout(maxtime, "pathfind_failed", "pathfind_succeeded", "change_state");
	succeeded = result === "pathfind_succeeded";
	return succeeded;
}

/*
	Name: waittill_asm_terminated
	Namespace: vehicle_ai
	Checksum: 0x99E99FB8
	Offset: 0x1280
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function waittill_asm_terminated()
{
	self endon(#"death");
	self notify(#"end_asm_terminated_thread");
	self endon(#"end_asm_terminated_thread");
	self waittill(#"asm_terminated");
	self notify(#"asm_complete", "__terminated__");
}

/*
	Name: waittill_asm_timeout
	Namespace: vehicle_ai
	Checksum: 0x8E8CB833
	Offset: 0x12D8
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function waittill_asm_timeout(timeout)
{
	self endon(#"death");
	self notify(#"end_asm_timeout_thread");
	self endon(#"end_asm_timeout_thread");
	wait(timeout);
	self notify(#"asm_complete", "__timeout__");
}

/*
	Name: waittill_asm_complete
	Namespace: vehicle_ai
	Checksum: 0x5301D55D
	Offset: 0x1330
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function waittill_asm_complete(substate_to_wait, timeout = 10)
{
	self endon(#"death");
	self thread waittill_asm_terminated();
	self thread waittill_asm_timeout(timeout);
	substate = undefined;
	while(!isdefined(substate) || (substate != substate_to_wait && substate != "__terminated__" && substate != "__timeout__"))
	{
		self waittill(#"asm_complete", substate);
	}
	self notify(#"end_asm_terminated_thread");
	self notify(#"end_asm_timeout_thread");
}

/*
	Name: throw_off_balance
	Namespace: vehicle_ai
	Checksum: 0xA47B5BCB
	Offset: 0x1410
	Size: 0x1E4
	Parameters: 4
	Flags: None
*/
function throw_off_balance(damagetype, hitpoint, hitdirection, hitlocationinfo)
{
	if(damagetype == "MOD_EXPLOSIVE" || damagetype == "MOD_GRENADE_SPLASH" || damagetype == "MOD_PROJECTILE_SPLASH")
	{
		self setvehvelocity(self.velocity + (vectornormalize(hitdirection) * 300));
		ang_vel = self getangularvelocity();
		ang_vel = ang_vel + (randomfloatrange(-300, 300), randomfloatrange(-300, 300), randomfloatrange(-300, 300));
		self setangularvelocity(ang_vel);
	}
	else
	{
		ang_vel = self getangularvelocity();
		yaw_vel = randomfloatrange(-320, 320);
		yaw_vel = yaw_vel + (math::sign(yaw_vel) * 150);
		ang_vel = ang_vel + (randomfloatrange(-150, 150), yaw_vel, randomfloatrange(-150, 150));
		self setangularvelocity(ang_vel);
	}
}

/*
	Name: predicted_collision
	Namespace: vehicle_ai
	Checksum: 0xE005A867
	Offset: 0x1600
	Size: 0x7A
	Parameters: 0
	Flags: None
*/
function predicted_collision()
{
	self endon(#"crash_done");
	self endon(#"death");
	while(true)
	{
		self waittill(#"veh_predictedcollision", velocity, normal);
		if(normal[2] >= 0.6)
		{
			self notify(#"veh_collision", velocity, normal);
		}
	}
}

/*
	Name: collision_fx
	Namespace: vehicle_ai
	Checksum: 0xED4A3458
	Offset: 0x1688
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function collision_fx(normal)
{
	tilted = normal[2] < 0.6;
	fx_origin = self.origin - (normal * (tilted ? 28 : 10));
	self playsound("veh_wasp_wall_imp");
}

/*
	Name: nudge_collision
	Namespace: vehicle_ai
	Checksum: 0x65F8C6EB
	Offset: 0x1710
	Size: 0x3CE
	Parameters: 0
	Flags: Linked
*/
function nudge_collision()
{
	self endon(#"crash_done");
	self endon(#"power_off_done");
	self endon(#"death");
	self notify(#"end_nudge_collision");
	self endon(#"end_nudge_collision");
	if(self.notsolid === 1)
	{
		return;
	}
	while(true)
	{
		self waittill(#"veh_collision", velocity, normal);
		ang_vel = self getangularvelocity() * 0.5;
		self setangularvelocity(ang_vel);
		empedoroff = self get_current_state() === "emped" || self get_current_state() === "off";
		if(isalive(self) && (normal[2] < 0.6 || !empedoroff))
		{
			self setvehvelocity(self.velocity + (normal * 90));
			self collision_fx(normal);
		}
		else
		{
			if(empedoroff)
			{
				if(isdefined(self.bounced))
				{
					self playsound("veh_wasp_wall_imp");
					self setvehvelocity((0, 0, 0));
					self setangularvelocity((0, 0, 0));
					pitch = self.angles[0];
					pitch = math::sign(pitch) * math::clamp(abs(pitch), 10, 15);
					self.angles = (pitch, self.angles[1], self.angles[2]);
					self.bounced = undefined;
					self notify(#"landed");
					return;
				}
				self.bounced = 1;
				self setvehvelocity(self.velocity + (normal * 30));
				self collision_fx(normal);
			}
			else
			{
				impact_vel = abs(vectordot(velocity, normal));
				if(normal[2] < 0.6 && impact_vel < 100)
				{
					self setvehvelocity(self.velocity + (normal * 90));
					self collision_fx(normal);
				}
				else
				{
					self playsound("veh_wasp_ground_death");
					self thread vehicle_death::death_fire_loop_audio();
					self notify(#"crash_done");
				}
			}
		}
	}
}

/*
	Name: level_out_for_landing
	Namespace: vehicle_ai
	Checksum: 0xC717CF64
	Offset: 0x1AE8
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function level_out_for_landing()
{
	self endon(#"death");
	self endon(#"change_state");
	self endon(#"landed");
	while(true)
	{
		velocity = self.velocity;
		self.angles = (self.angles[0] * 0.85, self.angles[1], self.angles[2] * 0.85);
		ang_vel = self getangularvelocity() * 0.85;
		self setangularvelocity(ang_vel);
		self setvehvelocity(velocity + (vectorscale((0, 0, -1), 60)));
		wait(0.05);
	}
}

/*
	Name: immolate
	Namespace: vehicle_ai
	Checksum: 0x2714A9F2
	Offset: 0x1BF0
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function immolate(attacker)
{
	self endon(#"death");
	self thread burning_thread(attacker, attacker);
}

/*
	Name: burning_thread
	Namespace: vehicle_ai
	Checksum: 0x5D375F20
	Offset: 0x1C30
	Size: 0x2A4
	Parameters: 2
	Flags: Linked
*/
function burning_thread(attacker, inflictor)
{
	self endon(#"death");
	self notify(#"end_immolating_thread");
	self endon(#"end_immolating_thread");
	damagepersecond = self.settings.burn_damagepersecond;
	if(!isdefined(damagepersecond) || damagepersecond <= 0)
	{
		return;
	}
	secondsperonedamage = 1 / float(damagepersecond);
	if(!isdefined(self.abnormal_status))
	{
		self.abnormal_status = spawnstruct();
	}
	if(self.abnormal_status.burning !== 1)
	{
		self vehicle::toggle_burn_fx(1);
	}
	self.abnormal_status.burning = 1;
	self.abnormal_status.attacker = attacker;
	self.abnormal_status.inflictor = inflictor;
	lastingtime = self.settings.burn_lastingtime;
	if(!isdefined(lastingtime))
	{
		lastingtime = 999999;
	}
	starttime = gettime();
	interval = max(secondsperonedamage, 0.5);
	damage = 0;
	while(timesince(starttime) < lastingtime)
	{
		previoustime = gettime();
		wait(interval);
		damage = damage + (timesince(previoustime) * damagepersecond);
		damageint = int(damage);
		self dodamage(damageint, self.origin, attacker, self, "none", "MOD_BURNED");
		damage = damage - damageint;
	}
	self.abnormal_status.burning = 0;
	self vehicle::toggle_burn_fx(0);
}

/*
	Name: iff_notifymeinnsec
	Namespace: vehicle_ai
	Checksum: 0xA0435258
	Offset: 0x1EE0
	Size: 0x2E
	Parameters: 2
	Flags: Linked
*/
function iff_notifymeinnsec(time, note)
{
	self endon(#"death");
	wait(time);
	self notify(note);
}

/*
	Name: iff_override
	Namespace: vehicle_ai
	Checksum: 0x4EF27CD4
	Offset: 0x1F18
	Size: 0x1E4
	Parameters: 2
	Flags: None
*/
function iff_override(owner, time = 60)
{
	self endon(#"death");
	self._iffoverride_oldteam = self.team;
	self iff_override_team_switch_behavior(owner.team);
	if(isdefined(self.iff_override_cb))
	{
		self [[self.iff_override_cb]](1);
	}
	if(isdefined(self.settings) && (!(isdefined(self.settings.iffshouldrevertteam) && self.settings.iffshouldrevertteam)))
	{
		return;
	}
	timeout = (isdefined(self.settings) ? self.settings.ifftimetillrevert : time);
	/#
		assert(timeout > 10);
	#/
	self thread iff_notifymeinnsec(timeout - 10, "iff_override_revert_warn");
	msg = self util::waittill_any_timeout(timeout, "iff_override_reverted", "death");
	if(msg == "timeout")
	{
		self notify(#"iff_override_reverted");
	}
	self playsound("gdt_iff_deactivate");
	self iff_override_team_switch_behavior(self._iffoverride_oldteam);
	if(isdefined(self.iff_override_cb))
	{
		self [[self.iff_override_cb]](0);
	}
}

/*
	Name: iff_override_team_switch_behavior
	Namespace: vehicle_ai
	Checksum: 0xA9B1A471
	Offset: 0x2108
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function iff_override_team_switch_behavior(team)
{
	self endon(#"death");
	old_ignoreme = self.ignoreme;
	self.ignoreme = 1;
	self start_scripted();
	self vehicle::lights_off();
	wait(0.1);
	wait(1);
	self setteam(team);
	self blink_lights_for_time(1);
	self stop_scripted();
	wait(1);
	self.ignoreme = old_ignoreme;
}

/*
	Name: blink_lights_for_time
	Namespace: vehicle_ai
	Checksum: 0x73D09BB3
	Offset: 0x21E0
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function blink_lights_for_time(time)
{
	self endon(#"death");
	starttime = gettime();
	self vehicle::lights_off();
	wait(0.1);
	while(gettime() < (starttime + (time * 1000)))
	{
		self vehicle::lights_off();
		wait(0.2);
		self vehicle::lights_on();
		wait(0.2);
	}
	self vehicle::lights_on();
}

/*
	Name: turnoff
	Namespace: vehicle_ai
	Checksum: 0x97DB72E5
	Offset: 0x22A0
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function turnoff()
{
	self notify(#"shut_off");
}

/*
	Name: turnon
	Namespace: vehicle_ai
	Checksum: 0x65CFFD1C
	Offset: 0x22C0
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function turnon()
{
	self notify(#"start_up");
}

/*
	Name: turnoffalllightsandlaser
	Namespace: vehicle_ai
	Checksum: 0xB60EE7CE
	Offset: 0x22E0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function turnoffalllightsandlaser()
{
	self laseroff();
	self vehicle::lights_off();
	self vehicle::toggle_lights_group(1, 0);
	self vehicle::toggle_lights_group(2, 0);
	self vehicle::toggle_lights_group(3, 0);
	self vehicle::toggle_lights_group(4, 0);
	self vehicle::toggle_burn_fx(0);
	self vehicle::toggle_emp_fx(0);
}

/*
	Name: turnoffallambientanims
	Namespace: vehicle_ai
	Checksum: 0x19D9D6C
	Offset: 0x23B0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function turnoffallambientanims()
{
	self vehicle::toggle_ambient_anim_group(1, 0);
	self vehicle::toggle_ambient_anim_group(2, 0);
	self vehicle::toggle_ambient_anim_group(3, 0);
}

/*
	Name: clearalllookingandtargeting
	Namespace: vehicle_ai
	Checksum: 0x57B7DEBE
	Offset: 0x2408
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function clearalllookingandtargeting()
{
	self cleartargetentity();
	self cleargunnertarget(0);
	self cleargunnertarget(1);
	self cleargunnertarget(2);
	self cleargunnertarget(3);
	self clearlookatent();
}

/*
	Name: clearallmovement
	Namespace: vehicle_ai
	Checksum: 0xD8363931
	Offset: 0x24A8
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function clearallmovement(zerooutspeed = 0)
{
	if(!isairborne(self))
	{
		self cancelaimove();
	}
	self clearvehgoalpos();
	self pathvariableoffsetclear();
	self pathfixedoffsetclear();
	if(zerooutspeed === 1)
	{
		self notify(#"landed");
		self setvehvelocity((0, 0, 0));
		self setphysacceleration((0, 0, 0));
		self setangularvelocity((0, 0, 0));
	}
}

/*
	Name: shared_callback_damage
	Namespace: vehicle_ai
	Checksum: 0xF298EA25
	Offset: 0x25A8
	Size: 0x240
	Parameters: 15
	Flags: Linked
*/
function shared_callback_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(should_emp(self, weapon, smeansofdeath, einflictor, eattacker))
	{
		minempdowntime = 0.8 * self.settings.empdowntime;
		maxempdowntime = 1.2 * self.settings.empdowntime;
		self notify(#"emped", randomfloatrange(minempdowntime, maxempdowntime), eattacker, einflictor);
	}
	if(should_burn(self, weapon, smeansofdeath, einflictor, eattacker))
	{
		self thread burning_thread(eattacker, einflictor);
	}
	if(!isdefined(self.damagelevel))
	{
		self.damagelevel = 0;
		self.newdamagelevel = self.damagelevel;
	}
	newdamagelevel = vehicle::should_update_damage_fx_level(self.health, idamage, self.healthdefault);
	if(newdamagelevel > self.damagelevel)
	{
		self.newdamagelevel = newdamagelevel;
	}
	if(self.newdamagelevel > self.damagelevel)
	{
		self.damagelevel = self.newdamagelevel;
		if(self.pain_when_damagelevel_change === 1)
		{
			self notify(#"pain");
		}
		vehicle::set_damage_fx_level(self.damagelevel);
	}
	return idamage;
}

/*
	Name: should_emp
	Namespace: vehicle_ai
	Checksum: 0x8D3F4559
	Offset: 0x27F0
	Size: 0x158
	Parameters: 5
	Flags: Linked
*/
function should_emp(vehicle, weapon, meansofdeath, einflictor, eattacker)
{
	if(!isdefined(vehicle) || meansofdeath === "MOD_IMPACT" || vehicle.disableelectrodamage === 1)
	{
		return 0;
	}
	if(!(isdefined(weapon) && weapon.isemp || meansofdeath === "MOD_ELECTROCUTED"))
	{
		return 0;
	}
	causer = (isdefined(eattacker) ? eattacker : einflictor);
	if(!isdefined(causer))
	{
		return 1;
	}
	if(isai(causer) && isvehicle(causer))
	{
		return 0;
	}
	if(level.teambased)
	{
		return vehicle.team != causer.team;
	}
	if(isdefined(vehicle.owner))
	{
		return vehicle.owner != causer;
	}
	return vehicle != causer;
}

/*
	Name: should_burn
	Namespace: vehicle_ai
	Checksum: 0x39E2D8AA
	Offset: 0x2958
	Size: 0x158
	Parameters: 5
	Flags: Linked
*/
function should_burn(vehicle, weapon, meansofdeath, einflictor, eattacker)
{
	if(level.disablevehicleburndamage === 1 || vehicle.disableburndamage === 1)
	{
		return 0;
	}
	if(!isdefined(vehicle))
	{
		return 0;
	}
	if(meansofdeath !== "MOD_BURNED")
	{
		return 0;
	}
	if(vehicle === einflictor)
	{
		return 0;
	}
	causer = (isdefined(eattacker) ? eattacker : einflictor);
	if(!isdefined(causer))
	{
		return 1;
	}
	if(isai(causer) && isvehicle(causer))
	{
		return 0;
	}
	if(level.teambased)
	{
		return vehicle.team != causer.team;
	}
	if(isdefined(vehicle.owner))
	{
		return vehicle.owner != causer;
	}
	return vehicle != causer;
}

/*
	Name: startinitialstate
	Namespace: vehicle_ai
	Checksum: 0xC9CB0B6
	Offset: 0x2AC0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function startinitialstate(defaultstate = "combat")
{
	params = spawnstruct();
	params.isinitialstate = 1;
	if(isdefined(self.script_startstate))
	{
		self set_state(self.script_startstate, params);
	}
	else
	{
		self set_state(defaultstate, params);
	}
}

/*
	Name: start_scripted
	Namespace: vehicle_ai
	Checksum: 0xF60E461D
	Offset: 0x2B70
	Size: 0x70
	Parameters: 2
	Flags: Linked
*/
function start_scripted(disable_death_state, no_clear_movement)
{
	params = spawnstruct();
	params.no_clear_movement = no_clear_movement;
	self set_state("scripted", params);
	self._no_death_state = disable_death_state;
}

/*
	Name: stop_scripted
	Namespace: vehicle_ai
	Checksum: 0x804A0AA4
	Offset: 0x2BE8
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function stop_scripted(statename)
{
	if(isalive(self) && is_instate("scripted"))
	{
		if(isdefined(statename))
		{
			self set_state(statename);
		}
		else
		{
			self set_state("combat");
		}
	}
}

/*
	Name: set_role
	Namespace: vehicle_ai
	Checksum: 0x482669B3
	Offset: 0x2C78
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function set_role(rolename)
{
	self.current_role = rolename;
}

/*
	Name: set_state
	Namespace: vehicle_ai
	Checksum: 0x103EF3B8
	Offset: 0x2C98
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function set_state(name, params)
{
	self.state_machines[self.current_role] thread statemachine::set_state(name, params);
}

/*
	Name: evaluate_connections
	Namespace: vehicle_ai
	Checksum: 0xA4DF6ED6
	Offset: 0x2CE8
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function evaluate_connections(eval_func, params)
{
	self.state_machines[self.current_role] statemachine::evaluate_connections(eval_func, params);
}

/*
	Name: get_state_callbacks
	Namespace: vehicle_ai
	Checksum: 0x94835341
	Offset: 0x2D38
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function get_state_callbacks(statename)
{
	rolename = "default";
	if(isdefined(self.current_role))
	{
		rolename = self.current_role;
	}
	if(isdefined(self.state_machines[rolename]))
	{
		return self.state_machines[rolename].states[statename];
	}
	return undefined;
}

/*
	Name: get_state_callbacks_for_role
	Namespace: vehicle_ai
	Checksum: 0xABBD9BAD
	Offset: 0x2DB0
	Size: 0x60
	Parameters: 2
	Flags: None
*/
function get_state_callbacks_for_role(rolename = "default", statename)
{
	if(isdefined(self.state_machines[rolename]))
	{
		return self.state_machines[rolename].states[statename];
	}
	return undefined;
}

/*
	Name: get_current_state
	Namespace: vehicle_ai
	Checksum: 0xC002AEE0
	Offset: 0x2E18
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function get_current_state()
{
	if(isdefined(self.current_role) && isdefined(self.state_machines[self.current_role].current_state))
	{
		return self.state_machines[self.current_role].current_state.name;
	}
	return undefined;
}

/*
	Name: get_previous_state
	Namespace: vehicle_ai
	Checksum: 0x8FDB09E1
	Offset: 0x2E78
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function get_previous_state()
{
	if(isdefined(self.current_role) && isdefined(self.state_machines[self.current_role].previous_state))
	{
		return self.state_machines[self.current_role].previous_state.name;
	}
	return undefined;
}

/*
	Name: get_next_state
	Namespace: vehicle_ai
	Checksum: 0xE9CFF409
	Offset: 0x2ED8
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function get_next_state()
{
	if(isdefined(self.current_role) && isdefined(self.state_machines[self.current_role].next_state))
	{
		return self.state_machines[self.current_role].next_state.name;
	}
	return undefined;
}

/*
	Name: is_instate
	Namespace: vehicle_ai
	Checksum: 0x3A1AA4BF
	Offset: 0x2F38
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function is_instate(statename)
{
	if(isdefined(self.current_role) && isdefined(self.state_machines[self.current_role].current_state))
	{
		return self.state_machines[self.current_role].current_state.name === statename;
	}
	return 0;
}

/*
	Name: add_state
	Namespace: vehicle_ai
	Checksum: 0xD793377D
	Offset: 0x2FA8
	Size: 0x90
	Parameters: 4
	Flags: Linked
*/
function add_state(name, enter_func, update_func, exit_func)
{
	if(isdefined(self.current_role))
	{
		statemachine = self.state_machines[self.current_role];
		if(isdefined(statemachine))
		{
			state = statemachine statemachine::add_state(name, enter_func, update_func, exit_func);
			return state;
		}
	}
	return undefined;
}

/*
	Name: add_interrupt_connection
	Namespace: vehicle_ai
	Checksum: 0x15382124
	Offset: 0x3040
	Size: 0x5C
	Parameters: 4
	Flags: Linked
*/
function add_interrupt_connection(from_state_name, to_state_name, on_notify, checkfunc)
{
	self.state_machines[self.current_role] statemachine::add_interrupt_connection(from_state_name, to_state_name, on_notify, checkfunc);
}

/*
	Name: add_utility_connection
	Namespace: vehicle_ai
	Checksum: 0x9ACD29F8
	Offset: 0x30A8
	Size: 0x5C
	Parameters: 4
	Flags: Linked
*/
function add_utility_connection(from_state_name, to_state_name, checkfunc, defaultscore)
{
	self.state_machines[self.current_role] statemachine::add_utility_connection(from_state_name, to_state_name, checkfunc, defaultscore);
}

/*
	Name: init_state_machine_for_role
	Namespace: vehicle_ai
	Checksum: 0xAC220F89
	Offset: 0x3110
	Size: 0x708
	Parameters: 1
	Flags: Linked
*/
function init_state_machine_for_role(rolename = "default")
{
	statemachine = statemachine::create(rolename, self);
	statemachine.isrole = 1;
	if(!isdefined(self.current_role))
	{
		set_role(rolename);
	}
	statemachine statemachine::add_state("suspend", undefined, undefined, undefined);
	statemachine statemachine::add_state("death", &defaultstate_death_enter, &defaultstate_death_update, undefined);
	statemachine statemachine::add_state("scripted", &defaultstate_scripted_enter, undefined, &defaultstate_scripted_exit);
	statemachine statemachine::add_state("combat", &defaultstate_combat_enter, undefined, &defaultstate_combat_exit);
	statemachine statemachine::add_state("emped", &defaultstate_emped_enter, &defaultstate_emped_update, &defaultstate_emped_exit, &defaultstate_emped_reenter);
	statemachine statemachine::add_state("surge", &defaultstate_surge_enter, &defaultstate_surge_update, &defaultstate_surge_exit);
	statemachine statemachine::add_state("off", &defaultstate_off_enter, undefined, &defaultstate_off_exit);
	statemachine statemachine::add_state("driving", &defaultstate_driving_enter, undefined, &defaultstate_driving_exit);
	statemachine statemachine::add_state("pain", &defaultstate_pain_enter, undefined, &defaultstate_pain_exit);
	statemachine statemachine::add_interrupt_connection("off", "combat", "start_up");
	statemachine statemachine::add_interrupt_connection("driving", "combat", "exit_vehicle");
	statemachine statemachine::add_utility_connection("emped", "combat");
	statemachine statemachine::add_utility_connection("pain", "combat");
	statemachine statemachine::add_interrupt_connection("combat", "emped", "emped");
	statemachine statemachine::add_interrupt_connection("pain", "emped", "emped");
	statemachine statemachine::add_interrupt_connection("emped", "emped", "emped");
	statemachine statemachine::add_interrupt_connection("combat", "surge", "surge");
	statemachine statemachine::add_interrupt_connection("off", "surge", "surge");
	statemachine statemachine::add_interrupt_connection("pain", "surge", "surge");
	statemachine statemachine::add_interrupt_connection("emped", "surge", "surge");
	statemachine statemachine::add_interrupt_connection("combat", "off", "shut_off");
	statemachine statemachine::add_interrupt_connection("emped", "off", "shut_off");
	statemachine statemachine::add_interrupt_connection("pain", "off", "shut_off");
	statemachine statemachine::add_interrupt_connection("combat", "driving", "enter_vehicle");
	statemachine statemachine::add_interrupt_connection("emped", "driving", "enter_vehicle");
	statemachine statemachine::add_interrupt_connection("off", "driving", "enter_vehicle");
	statemachine statemachine::add_interrupt_connection("pain", "driving", "enter_vehicle");
	statemachine statemachine::add_interrupt_connection("combat", "pain", "pain");
	statemachine statemachine::add_interrupt_connection("emped", "pain", "pain");
	statemachine statemachine::add_interrupt_connection("off", "pain", "pain");
	statemachine statemachine::add_interrupt_connection("driving", "pain", "pain");
	self.overridevehiclekilled = &callback_vehiclekilled;
	self.overridevehicledeathpostgame = &callback_vehiclekilled;
	statemachine thread statemachine::set_state("suspend");
	self thread on_death_cleanup();
	return statemachine;
}

/*
	Name: register_custom_add_state_callback
	Namespace: vehicle_ai
	Checksum: 0x8257BE41
	Offset: 0x3820
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function register_custom_add_state_callback(func)
{
	if(!isdefined(level.level_specific_add_state_callbacks))
	{
		level.level_specific_add_state_callbacks = [];
	}
	level.level_specific_add_state_callbacks[level.level_specific_add_state_callbacks.size] = func;
}

/*
	Name: call_custom_add_state_callbacks
	Namespace: vehicle_ai
	Checksum: 0x43A38276
	Offset: 0x3868
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function call_custom_add_state_callbacks()
{
	if(isdefined(level.level_specific_add_state_callbacks))
	{
		for(i = 0; i < level.level_specific_add_state_callbacks.size; i++)
		{
			self [[level.level_specific_add_state_callbacks[i]]]();
		}
	}
}

/*
	Name: callback_vehiclekilled
	Namespace: vehicle_ai
	Checksum: 0x8BB9CDE8
	Offset: 0x38C8
	Size: 0x13C
	Parameters: 8
	Flags: Linked
*/
function callback_vehiclekilled(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	if(isdefined(self._no_death_state) && self._no_death_state)
	{
		return;
	}
	death_info = spawnstruct();
	death_info.inflictor = einflictor;
	death_info.attacker = eattacker;
	death_info.damage = idamage;
	death_info.meansofdeath = smeansofdeath;
	death_info.weapon = weapon;
	death_info.dir = vdir;
	death_info.hitloc = shitloc;
	death_info.timeoffset = psoffsettime;
	self set_state("death", death_info);
}

/*
	Name: on_death_cleanup
	Namespace: vehicle_ai
	Checksum: 0xCACA5A10
	Offset: 0x3A10
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function on_death_cleanup()
{
	state_machines = self.state_machines;
	self waittill(#"free_vehicle");
	foreach(statemachine in state_machines)
	{
		statemachine statemachine::clear();
	}
}

/*
	Name: defaultstate_death_enter
	Namespace: vehicle_ai
	Checksum: 0xE02EC71C
	Offset: 0x3AC8
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function defaultstate_death_enter(params)
{
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	self disableaimassist();
	turnoffalllightsandlaser();
	turnoffallambientanims();
	clearalllookingandtargeting();
	clearallmovement();
	self cancelaimove();
	self.takedamage = 0;
	self vehicle_death::death_cleanup_level_variables();
}

/*
	Name: burning_death_fx
	Namespace: vehicle_ai
	Checksum: 0x44040A95
	Offset: 0x3BB8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function burning_death_fx()
{
	if(isdefined(self.settings.burn_death_fx_1) && isdefined(self.settings.burn_death_tag_1))
	{
		playfxontag(self.settings.burn_death_fx_1, self, self.settings.burn_death_tag_1);
	}
	if(isdefined(self.settings.burn_death_sound_1))
	{
		self playsound(self.settings.burn_death_sound_1);
	}
}

/*
	Name: emp_death_fx
	Namespace: vehicle_ai
	Checksum: 0x9C7D97ED
	Offset: 0x3C58
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function emp_death_fx()
{
	if(isdefined(self.settings.emp_death_fx_1) && isdefined(self.settings.emp_death_tag_1))
	{
		playfxontag(self.settings.emp_death_fx_1, self, self.settings.emp_death_tag_1);
	}
	if(isdefined(self.settings.emp_death_sound_1))
	{
		self playsound(self.settings.emp_death_sound_1);
	}
}

/*
	Name: death_radius_damage_special
	Namespace: vehicle_ai
	Checksum: 0xC721E0B8
	Offset: 0x3CF8
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function death_radius_damage_special(radiusscale, meansofdamage)
{
	self endon(#"death");
	if(!isdefined(self) || self.abandoned === 1 || self.damage_on_death === 0 || self.radiusdamageradius <= 0)
	{
		return;
	}
	position = self.origin + vectorscale((0, 0, 1), 15);
	radius = self.radiusdamageradius * radiusscale;
	damagemax = self.radiusdamagemax;
	damagemin = self.radiusdamagemin;
	wait(0.05);
	if(isdefined(self))
	{
		self radiusdamage(position, radius, damagemax, damagemin, undefined, meansofdamage);
	}
}

/*
	Name: burning_death
	Namespace: vehicle_ai
	Checksum: 0xAC931E75
	Offset: 0x3E00
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function burning_death(params)
{
	self endon(#"death");
	self burning_death_fx();
	self.skipfriendlyfirecheck = 1;
	self thread death_radius_damage_special(2, "MOD_BURNED");
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::do_death_dynents(3);
	self vehicle_death::deletewhensafe(10);
}

/*
	Name: emped_death
	Namespace: vehicle_ai
	Checksum: 0x29D146A6
	Offset: 0x3EC0
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function emped_death(params)
{
	self endon(#"death");
	self emp_death_fx();
	self.skipfriendlyfirecheck = 1;
	self thread death_radius_damage_special(2, "MOD_ELECTROCUTED");
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::do_death_dynents(2);
	self vehicle_death::deletewhensafe();
}

/*
	Name: gibbed_death
	Namespace: vehicle_ai
	Checksum: 0xC997F7B6
	Offset: 0x3F80
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function gibbed_death(params)
{
	self endon(#"death");
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::do_death_dynents();
	self vehicle_death::deletewhensafe();
}

/*
	Name: default_death
	Namespace: vehicle_ai
	Checksum: 0x198E5E5E
	Offset: 0x4028
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function default_death(params)
{
	self endon(#"death");
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	if(isdefined(level.disable_thermal))
	{
		[[level.disable_thermal]]();
	}
	waittime = (isdefined(self.waittime_before_delete) ? self.waittime_before_delete : 0);
	owner = self getvehicleowner();
	if(isdefined(owner) && self isremotecontrol())
	{
		waittime = max(waittime, 4);
	}
	util::waitfortime(waittime);
	vehicle_death::freewhensafe();
}

/*
	Name: get_death_type
	Namespace: vehicle_ai
	Checksum: 0x714F3E04
	Offset: 0x4168
	Size: 0x108
	Parameters: 1
	Flags: Linked
*/
function get_death_type(params)
{
	if(self.delete_on_death === 1)
	{
		death_type = "default";
	}
	else
	{
		death_type = self.death_type;
	}
	if(!isdefined(death_type))
	{
		death_type = params.death_type;
	}
	if(!isdefined(death_type) && isdefined(self.abnormal_status) && self.abnormal_status.burning === 1)
	{
		death_type = "burning";
	}
	if(!isdefined(death_type) && (isdefined(self.abnormal_status) && self.abnormal_status.emped === 1) || (isdefined(params.weapon) && params.weapon.isemp))
	{
		death_type = "emped";
	}
	return death_type;
}

/*
	Name: defaultstate_death_update
	Namespace: vehicle_ai
	Checksum: 0x8F11CEEA
	Offset: 0x4278
	Size: 0x14E
	Parameters: 1
	Flags: Linked
*/
function defaultstate_death_update(params)
{
	self endon(#"death");
	if(isdefined(level.vehicle_destructer_cb))
	{
		[[level.vehicle_destructer_cb]](self);
	}
	if(self.delete_on_death === 1)
	{
		default_death(params);
		vehicle_death::deletewhensafe(0.25);
	}
	else
	{
		death_type = (isdefined(get_death_type(params)) ? get_death_type(params) : "default");
		switch(death_type)
		{
			case "burning":
			{
				burning_death(params);
				break;
			}
			case "emped":
			{
				emped_death(params);
				break;
			}
			case "gibbed":
			{
				gibbed_death(params);
				break;
			}
			default:
			{
				default_death(params);
				break;
			}
		}
	}
}

/*
	Name: defaultstate_scripted_enter
	Namespace: vehicle_ai
	Checksum: 0x803457C
	Offset: 0x43D0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function defaultstate_scripted_enter(params)
{
	if(params.no_clear_movement !== 1)
	{
		clearalllookingandtargeting();
		clearallmovement();
		if(hasasm(self))
		{
			self asmrequestsubstate("locomotion@movement");
		}
		self resumespeed();
	}
}

/*
	Name: defaultstate_scripted_exit
	Namespace: vehicle_ai
	Checksum: 0xB063C4A5
	Offset: 0x4470
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function defaultstate_scripted_exit(params)
{
	if(params.no_clear_movement !== 1)
	{
		clearalllookingandtargeting();
		clearallmovement();
	}
}

/*
	Name: defaultstate_combat_enter
	Namespace: vehicle_ai
	Checksum: 0x23C8A6E3
	Offset: 0x44C0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function defaultstate_combat_enter(params)
{
}

/*
	Name: defaultstate_combat_exit
	Namespace: vehicle_ai
	Checksum: 0x5145A6B6
	Offset: 0x44D8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function defaultstate_combat_exit(params)
{
}

/*
	Name: defaultstate_emped_enter
	Namespace: vehicle_ai
	Checksum: 0x860AD2B
	Offset: 0x44F0
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function defaultstate_emped_enter(params)
{
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	params.laseron = islaseron(self);
	self laseroff();
	self vehicle::lights_off();
	clearalllookingandtargeting();
	clearallmovement();
	if(isairborne(self))
	{
		self setrotorspeed(0);
	}
	if(!isdefined(self.abnormal_status))
	{
		self.abnormal_status = spawnstruct();
	}
	self.abnormal_status.emped = 1;
	self.abnormal_status.attacker = params.notify_param[1];
	self.abnormal_status.inflictor = params.notify_param[2];
	self vehicle::toggle_emp_fx(1);
}

/*
	Name: emp_startup_fx
	Namespace: vehicle_ai
	Checksum: 0x4AB811EB
	Offset: 0x4690
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function emp_startup_fx()
{
	if(isdefined(self.settings.emp_startup_fx_1) && isdefined(self.settings.emp_startup_tag_1))
	{
		playfxontag(self.settings.emp_startup_fx_1, self, self.settings.emp_startup_tag_1);
	}
}

/*
	Name: defaultstate_emped_update
	Namespace: vehicle_ai
	Checksum: 0x96A1A4D2
	Offset: 0x46F8
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function defaultstate_emped_update(params)
{
	self endon(#"death");
	self endon(#"change_state");
	time = params.notify_param[0];
	/#
		assert(isdefined(time));
	#/
	cooldown("emped_timer", time);
	while(!iscooldownready("emped_timer"))
	{
		timeleft = max(getcooldownleft("emped_timer"), 0.5);
		wait(timeleft);
	}
	self.abnormal_status.emped = 0;
	self vehicle::toggle_emp_fx(0);
	self emp_startup_fx();
	wait(1);
	self evaluate_connections();
}

/*
	Name: defaultstate_emped_exit
	Namespace: vehicle_ai
	Checksum: 0xBD2FCDC0
	Offset: 0x4838
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function defaultstate_emped_exit(params)
{
	self vehicle::toggle_tread_fx(1);
	self vehicle::toggle_exhaust_fx(1);
	self vehicle::toggle_sounds(1);
	if(params.laseron === 1)
	{
		self laseron();
	}
	self vehicle::lights_on();
	if(isairborne(self))
	{
		self setphysacceleration((0, 0, 0));
		self thread nudge_collision();
		self setrotorspeed(1);
	}
}

/*
	Name: defaultstate_emped_reenter
	Namespace: vehicle_ai
	Checksum: 0x2FF93DC7
	Offset: 0x4940
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function defaultstate_emped_reenter(params)
{
	return true;
}

/*
	Name: defaultstate_surge_enter
	Namespace: vehicle_ai
	Checksum: 0x52E18E5C
	Offset: 0x4958
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function defaultstate_surge_enter(params)
{
}

/*
	Name: defaultstate_surge_exit
	Namespace: vehicle_ai
	Checksum: 0x53C40913
	Offset: 0x4970
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function defaultstate_surge_exit(params)
{
}

/*
	Name: defaultstate_surge_update
	Namespace: vehicle_ai
	Checksum: 0x91FB6384
	Offset: 0x4988
	Size: 0x404
	Parameters: 1
	Flags: Linked
*/
function defaultstate_surge_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	if(!isdefined(self.abnormal_status))
	{
		self.abnormal_status = spawnstruct();
	}
	self.abnormal_status.emped = 1;
	pathfailcount = 0;
	self thread flash_team_switching_lights();
	targets = getaiteamarray("axis", "team3");
	arrayremovevalue(targets, self);
	closest = arraygetclosest(self.origin, targets);
	self setspeed(self.settings.surgespeedmultiplier * self.settings.defaultmovespeed);
	starttime = gettime();
	self thread swap_team_after_time(params.notify_param[0]);
	while((gettime() - starttime) < (self.settings.surgetimetolive * 1000))
	{
		if(!isdefined(closest))
		{
			self detonate(params.notify_param[0]);
		}
		else
		{
			foundpath = 0;
			targetpos = closest.origin + vectorscale((0, 0, 1), 32);
			if(isdefined(targetpos))
			{
				queryresult = positionquery_source_navigation(targetpos, 0, 64, 35, 5, self);
				foreach(point in queryresult.data)
				{
					self.current_pathto_pos = point.origin;
					foundpath = self setvehgoalpos(self.current_pathto_pos, 0, 1);
					if(foundpath)
					{
						self thread path_update_interrupt(closest, params.notify_param[0]);
						pathfailcount = 0;
						self waittill_pathing_done(self.settings.surgetimetolive);
						try_detonate(closest, params.notify_param[0]);
						break;
					}
					waittillframeend();
				}
			}
			if(!foundpath)
			{
				pathfailcount++;
				if(pathfailcount > 10)
				{
					self detonate(params.notify_param[0]);
				}
			}
			wait(0.2);
		}
	}
	if(isalive(self))
	{
		self detonate(params.notify_param[0]);
	}
}

/*
	Name: path_update_interrupt
	Namespace: vehicle_ai
	Checksum: 0x6BF2AF6A
	Offset: 0x4D98
	Size: 0xD8
	Parameters: 2
	Flags: Linked
*/
function path_update_interrupt(closest, attacker)
{
	self endon(#"death");
	self endon(#"change_state");
	self endon(#"near_goal");
	self endon(#"reached_end_node");
	wait(0.1);
	while(!self try_detonate(closest, attacker))
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(distance2dsquared(self.current_pathto_pos, self.goalpos) > (self.goalradius * self.goalradius))
			{
				wait(0.5);
				self notify(#"near_goal");
			}
		}
		wait(0.1);
	}
}

/*
	Name: swap_team_after_time
	Namespace: vehicle_ai
	Checksum: 0x8A4A4BE3
	Offset: 0x4E78
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function swap_team_after_time(attacker)
{
	self endon(#"death");
	self endon(#"change_state");
	wait(0.25 * self.settings.surgetimetolive);
	self setteam(attacker.team);
}

/*
	Name: try_detonate
	Namespace: vehicle_ai
	Checksum: 0x567EFD0C
	Offset: 0x4EE8
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function try_detonate(closest, attacker)
{
	if(isdefined(closest) && isalive(closest))
	{
		if(distancesquared(closest.origin, self.origin) < (80 * 80))
		{
			self detonate(attacker);
			return true;
		}
	}
	return false;
}

/*
	Name: detonate
	Namespace: vehicle_ai
	Checksum: 0xDB4ACF74
	Offset: 0x4F80
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function detonate(attacker)
{
	self setteam(attacker.team);
	self radiusdamage(self.origin + vectorscale((0, 0, 1), 5), self.settings.surgedamageradius, 1500, 1000, attacker, "MOD_EXPLOSIVE");
	if(isalive(self))
	{
		self kill();
	}
}

/*
	Name: flash_team_switching_lights
	Namespace: vehicle_ai
	Checksum: 0xB397E217
	Offset: 0x5038
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function flash_team_switching_lights()
{
	self endon(#"death");
	self endon(#"change_state");
	while(true)
	{
		self vehicle::lights_off();
		wait(0.1);
		self vehicle::lights_on("allies");
		wait(0.1);
		self vehicle::lights_off();
		wait(0.1);
		self vehicle::lights_on("axis");
		wait(0.1);
	}
}

/*
	Name: defaultstate_off_enter
	Namespace: vehicle_ai
	Checksum: 0x2D8116F4
	Offset: 0x50F0
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function defaultstate_off_enter(params)
{
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	self disableaimassist();
	params.laseron = islaseron(self);
	turnoffalllightsandlaser();
	turnoffallambientanims();
	clearalllookingandtargeting();
	clearallmovement();
	if(isdefined(level.disable_thermal))
	{
		[[level.disable_thermal]]();
	}
	if(isairborne(self))
	{
		if(params.isinitialstate !== 1 && params.no_falling !== 1)
		{
			self setphysacceleration(vectorscale((0, 0, -1), 300));
			self thread level_out_for_landing();
		}
		self setrotorspeed(0);
	}
}

/*
	Name: defaultstate_off_exit
	Namespace: vehicle_ai
	Checksum: 0xA3D80445
	Offset: 0x5280
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function defaultstate_off_exit(params)
{
	self vehicle::toggle_tread_fx(1);
	self vehicle::toggle_exhaust_fx(1);
	self vehicle::toggle_sounds(1);
	self enableaimassist();
	if(isairborne(self))
	{
		self setphysacceleration((0, 0, 0));
		self thread nudge_collision();
		self setrotorspeed(1);
	}
	if(params.laseron === 1)
	{
		self laseron();
	}
	if(isdefined(level.enable_thermal))
	{
		if(self get_next_state() !== "death")
		{
			[[level.enable_thermal]]();
		}
	}
	self vehicle::lights_on();
}

/*
	Name: defaultstate_driving_enter
	Namespace: vehicle_ai
	Checksum: 0x20D8648F
	Offset: 0x53D8
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function defaultstate_driving_enter(params)
{
	params.driver = self getseatoccupant(0);
	/#
		assert(isdefined(params.driver));
	#/
	self disableaimassist();
	if(level.playersdrivingvehiclesbecomeinvulnerable)
	{
		params.driver enableinvulnerability();
		params.driver.ignoreme = 1;
	}
	self.turretrotscale = 1;
	self.team = params.driver.team;
	if(hasasm(self))
	{
		self asmrequestsubstate("locomotion@movement");
	}
	self setheliheightcap(1);
	clearalllookingandtargeting();
	clearallmovement();
	self cancelaimove();
	if(isdefined(params.driver) && !isdefined(self.customdamagemonitor))
	{
		self thread vehicle::monitor_damage_as_occupant(params.driver);
	}
}

/*
	Name: defaultstate_driving_exit
	Namespace: vehicle_ai
	Checksum: 0x3AC5D332
	Offset: 0x5590
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function defaultstate_driving_exit(params)
{
	self enableaimassist();
	if(isdefined(params.driver))
	{
		params.driver disableinvulnerability();
		params.driver.ignoreme = 0;
	}
	self.turretrotscale = 1;
	self setheliheightcap(0);
	clearalllookingandtargeting();
	clearallmovement();
	if(isdefined(params.driver))
	{
		params.driver vehicle::stop_monitor_damage_as_occupant();
	}
}

/*
	Name: defaultstate_pain_enter
	Namespace: vehicle_ai
	Checksum: 0x32BDD794
	Offset: 0x5678
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function defaultstate_pain_enter(params)
{
	clearalllookingandtargeting();
	clearallmovement();
}

/*
	Name: defaultstate_pain_exit
	Namespace: vehicle_ai
	Checksum: 0xDC743933
	Offset: 0x56B0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function defaultstate_pain_exit(params)
{
	clearalllookingandtargeting();
	clearallmovement();
}

/*
	Name: canseeenemyfromposition
	Namespace: vehicle_ai
	Checksum: 0xFDF6C837
	Offset: 0x56E8
	Size: 0x72
	Parameters: 3
	Flags: None
*/
function canseeenemyfromposition(position, enemy, sight_check_height)
{
	sightcheckorigin = position + (0, 0, sight_check_height);
	return sighttracepassed(sightcheckorigin, enemy.origin + vectorscale((0, 0, 1), 30), 0, self);
}

/*
	Name: findnewposition
	Namespace: vehicle_ai
	Checksum: 0x43AE0A34
	Offset: 0x5768
	Size: 0x7FE
	Parameters: 1
	Flags: None
*/
function findnewposition(sight_check_height)
{
	if(self.goalforced)
	{
		goalpos = getclosestpointonnavmesh(self.goalpos, self.radius * 2, self.radius);
		return goalpos;
	}
	point_spacing = 90;
	pixbeginevent("vehicle_ai_shared::FindNewPosition");
	queryresult = positionquery_source_navigation(self.origin, 0, 2000, 300, point_spacing, self, point_spacing * 2);
	pixendevent();
	positionquery_filter_random(queryresult, 0, 50);
	positionquery_filter_distancetogoal(queryresult, self);
	positionquery_filter_outofgoalanchor(queryresult, 50);
	origin = self.goalpos;
	best_point = undefined;
	best_score = -999999;
	if(isdefined(self.enemy))
	{
		positionquery_filter_sight(queryresult, self.enemy.origin, self geteye() - self.origin, self, 0, self.enemy);
		self positionquery_filter_engagementdist(queryresult, self.enemy, self.settings.engagementdistmin, self.settings.engagementdistmax);
		if(turret::has_turret(1))
		{
			side_turret_enemy = turret::get_target(1);
			if(isdefined(side_turret_enemy) && side_turret_enemy != self.enemy)
			{
				positionquery_filter_sight(queryresult, side_turret_enemy.origin, (0, 0, sight_check_height), self, 20, self, "sight2");
			}
		}
		if(turret::has_turret(2))
		{
			side_turret_enemy = turret::get_target(2);
			if(isdefined(side_turret_enemy) && side_turret_enemy != self.enemy)
			{
				positionquery_filter_sight(queryresult, side_turret_enemy.origin, (0, 0, sight_check_height), self, 20, self, "sight3");
			}
		}
		foreach(point in queryresult.data)
		{
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = point.distawayfromengagementarea * -1;
			#/
			point.score = point.score + (point.distawayfromengagementarea * -1);
			if(distance2dsquared(self.origin, point.origin) < 28900)
			{
				/#
					if(!isdefined(point._scoredebug))
					{
						point._scoredebug = [];
					}
					point._scoredebug[""] = -170;
				#/
				point.score = point.score + -170;
			}
			if(isdefined(point.sight) && point.sight)
			{
				/#
					if(!isdefined(point._scoredebug))
					{
						point._scoredebug = [];
					}
					point._scoredebug[""] = 250;
				#/
				point.score = point.score + 250;
			}
			if(isdefined(point.sight2) && point.sight2)
			{
				/#
					if(!isdefined(point._scoredebug))
					{
						point._scoredebug = [];
					}
					point._scoredebug[""] = 150;
				#/
				point.score = point.score + 150;
			}
			if(isdefined(point.sight3) && point.sight3)
			{
				/#
					if(!isdefined(point._scoredebug))
					{
						point._scoredebug = [];
					}
					point._scoredebug[""] = 150;
				#/
				point.score = point.score + 150;
			}
			if(point.score > best_score)
			{
				best_score = point.score;
				best_point = point;
			}
		}
	}
	else
	{
		foreach(point in queryresult.data)
		{
			if(distance2dsquared(self.origin, point.origin) < 28900)
			{
				/#
					if(!isdefined(point._scoredebug))
					{
						point._scoredebug = [];
					}
					point._scoredebug[""] = -100;
				#/
				point.score = point.score + -100;
			}
			if(point.score > best_score)
			{
				best_score = point.score;
				best_point = point;
			}
		}
	}
	self positionquery_debugscores(queryresult);
	if(isdefined(best_point))
	{
		/#
		#/
		origin = best_point.origin;
	}
	return origin + vectorscale((0, 0, 1), 10);
}

/*
	Name: timesince
	Namespace: vehicle_ai
	Checksum: 0xC25F5CA9
	Offset: 0x5F70
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function timesince(starttimeinmilliseconds)
{
	return (gettime() - starttimeinmilliseconds) * 0.001;
}

/*
	Name: cooldowninit
	Namespace: vehicle_ai
	Checksum: 0x5318DF93
	Offset: 0x5F98
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function cooldowninit()
{
	if(!isdefined(self._cooldown))
	{
		self._cooldown = [];
	}
}

/*
	Name: cooldown
	Namespace: vehicle_ai
	Checksum: 0x3D3EFF66
	Offset: 0x5FC0
	Size: 0x42
	Parameters: 2
	Flags: Linked
*/
function cooldown(name, time_seconds)
{
	cooldowninit();
	self._cooldown[name] = gettime() + (time_seconds * 1000);
}

/*
	Name: getcooldowntimeraw
	Namespace: vehicle_ai
	Checksum: 0xB7C6190C
	Offset: 0x6010
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function getcooldowntimeraw(name)
{
	cooldowninit();
	if(!isdefined(self._cooldown[name]))
	{
		self._cooldown[name] = gettime() - 1;
	}
	return self._cooldown[name];
}

/*
	Name: getcooldownleft
	Namespace: vehicle_ai
	Checksum: 0x31A30C44
	Offset: 0x6070
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function getcooldownleft(name)
{
	cooldowninit();
	return (getcooldowntimeraw(name) - gettime()) * 0.001;
}

/*
	Name: iscooldownready
	Namespace: vehicle_ai
	Checksum: 0x275E9D6A
	Offset: 0x60B8
	Size: 0x72
	Parameters: 2
	Flags: Linked
*/
function iscooldownready(name, timeforward_seconds)
{
	cooldowninit();
	if(!isdefined(timeforward_seconds))
	{
		timeforward_seconds = 0;
	}
	cooldownreadytime = self._cooldown[name];
	return !isdefined(cooldownreadytime) || (gettime() + (timeforward_seconds * 1000)) > cooldownreadytime;
}

/*
	Name: clearcooldown
	Namespace: vehicle_ai
	Checksum: 0x2A236979
	Offset: 0x6138
	Size: 0x32
	Parameters: 1
	Flags: None
*/
function clearcooldown(name)
{
	cooldowninit();
	self._cooldown[name] = gettime() - 1;
}

/*
	Name: addcooldowntime
	Namespace: vehicle_ai
	Checksum: 0x99DDD88A
	Offset: 0x6178
	Size: 0x56
	Parameters: 2
	Flags: None
*/
function addcooldowntime(name, time_seconds)
{
	cooldowninit();
	self._cooldown[name] = getcooldowntimeraw(name) + (time_seconds * 1000);
}

/*
	Name: clearallcooldowns
	Namespace: vehicle_ai
	Checksum: 0xBAAB30F4
	Offset: 0x61D8
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function clearallcooldowns()
{
	if(isdefined(self._cooldown))
	{
		foreach(str_name, cooldown in self._cooldown)
		{
			self._cooldown[str_name] = gettime() - 1;
		}
	}
}

/*
	Name: positionquery_debugscores
	Namespace: vehicle_ai
	Checksum: 0x299FCEFF
	Offset: 0x6278
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function positionquery_debugscores(queryresult)
{
	if(!(isdefined(getdvarint("hkai_debugPositionQuery")) && getdvarint("hkai_debugPositionQuery")))
	{
		return;
	}
	foreach(point in queryresult.data)
	{
		point debugscore(self);
	}
}

/*
	Name: debugscore
	Namespace: vehicle_ai
	Checksum: 0x7F59C836
	Offset: 0x6360
	Size: 0x1C2
	Parameters: 1
	Flags: Linked
*/
function debugscore(entity)
{
	/#
		if(!isdefined(self._scoredebug))
		{
			return;
		}
		if(!(isdefined(getdvarint("")) && getdvarint("")))
		{
			return;
		}
		step = 10;
		count = 1;
		color = (1, 0, 0);
		if(self.score >= 0)
		{
			color = (0, 1, 0);
		}
		recordstar(self.origin, color);
		record3dtext(("" + self.score) + "", self.origin - (0, 0, step * count), color);
		foreach(name, score in self._scoredebug)
		{
			count++;
			record3dtext((name + "") + score, self.origin - (0, 0, step * count), color);
		}
	#/
}

/*
	Name: _less_than_val
	Namespace: vehicle_ai
	Checksum: 0xB4AEAE62
	Offset: 0x6530
	Size: 0x40
	Parameters: 2
	Flags: Linked
*/
function _less_than_val(left, right)
{
	if(!isdefined(left))
	{
		return 0;
	}
	if(!isdefined(right))
	{
		return 1;
	}
	return left < right;
}

/*
	Name: _cmp_val
	Namespace: vehicle_ai
	Checksum: 0x3A65BD8A
	Offset: 0x6578
	Size: 0x5A
	Parameters: 3
	Flags: Linked
*/
function _cmp_val(left, right, descending)
{
	if(descending)
	{
		return _less_than_val(right, left);
	}
	return _less_than_val(left, right);
}

/*
	Name: _sort_by_score
	Namespace: vehicle_ai
	Checksum: 0xC47ABC03
	Offset: 0x65E0
	Size: 0x4A
	Parameters: 3
	Flags: Linked
*/
function _sort_by_score(left, right, descending)
{
	return _cmp_val(left.score, right.score, descending);
}

/*
	Name: positionquery_filter_random
	Namespace: vehicle_ai
	Checksum: 0x8EDEC30E
	Offset: 0x6638
	Size: 0x122
	Parameters: 3
	Flags: Linked
*/
function positionquery_filter_random(queryresult, min, max)
{
	foreach(point in queryresult.data)
	{
		score = randomfloatrange(min, max);
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = score;
		#/
		point.score = point.score + score;
	}
}

/*
	Name: positionquery_postprocess_sortscore
	Namespace: vehicle_ai
	Checksum: 0xB241D1A0
	Offset: 0x6768
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function positionquery_postprocess_sortscore(queryresult, descending = 1)
{
	sorted = array::merge_sort(queryresult.data, &_sort_by_score, descending);
	queryresult.data = sorted;
}

/*
	Name: positionquery_filter_outofgoalanchor
	Namespace: vehicle_ai
	Checksum: 0x74E4CBA1
	Offset: 0x67E8
	Size: 0x142
	Parameters: 2
	Flags: Linked
*/
function positionquery_filter_outofgoalanchor(queryresult, tolerance = 1)
{
	foreach(point in queryresult.data)
	{
		if(point.disttogoal > tolerance)
		{
			score = -10000 - (point.disttogoal * 10);
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = score;
			#/
			point.score = point.score + score;
		}
	}
}

/*
	Name: positionquery_filter_engagementdist
	Namespace: vehicle_ai
	Checksum: 0x4AA76431
	Offset: 0x6938
	Size: 0x33E
	Parameters: 4
	Flags: Linked
*/
function positionquery_filter_engagementdist(queryresult, enemy, engagementdistancemin, engagementdistancemax)
{
	if(!isdefined(enemy))
	{
		return;
	}
	engagementdistance = (engagementdistancemin + engagementdistancemax) * 0.5;
	half_engagement_width = abs(engagementdistancemax - engagementdistance);
	enemy_origin = (enemy.origin[0], enemy.origin[1], 0);
	vec_enemy_to_self = vectornormalize((self.origin[0], self.origin[1], 0) - enemy_origin);
	foreach(point in queryresult.data)
	{
		point.distawayfromengagementarea = 0;
		vec_enemy_to_point = (point.origin[0], point.origin[1], 0) - enemy_origin;
		dist_in_front_of_enemy = vectordot(vec_enemy_to_point, vec_enemy_to_self);
		if(abs(dist_in_front_of_enemy) < engagementdistancemin)
		{
			dist_in_front_of_enemy = engagementdistancemin * -1;
		}
		dist_away_from_sweet_line = abs(dist_in_front_of_enemy - engagementdistance);
		if(dist_away_from_sweet_line > half_engagement_width)
		{
			point.distawayfromengagementarea = dist_away_from_sweet_line - half_engagement_width;
		}
		too_far_dist = engagementdistancemax * 1.1;
		too_far_dist_sq = too_far_dist * too_far_dist;
		dist_from_enemy_sq = distance2dsquared(point.origin, enemy_origin);
		if(dist_from_enemy_sq > too_far_dist_sq)
		{
			ratiosq = dist_from_enemy_sq / too_far_dist_sq;
			dist = ratiosq * too_far_dist;
			dist_outside = dist - too_far_dist;
			if(dist_outside > point.distawayfromengagementarea)
			{
				point.distawayfromengagementarea = dist_outside;
			}
		}
	}
}

/*
	Name: positionquery_filter_distawayfromtarget
	Namespace: vehicle_ai
	Checksum: 0x53B3A1B3
	Offset: 0x6C80
	Size: 0x29E
	Parameters: 4
	Flags: Linked
*/
function positionquery_filter_distawayfromtarget(queryresult, targetarray, distance, tooclosepenalty)
{
	if(!isdefined(targetarray) || !isarray(targetarray))
	{
		return;
	}
	foreach(point in queryresult.data)
	{
		tooclose = 0;
		foreach(target in targetarray)
		{
			origin = undefined;
			if(isvec(target))
			{
				origin = target;
			}
			else
			{
				if(issentient(target) && isalive(target))
				{
					origin = target.origin;
				}
				else if(isentity(target))
				{
					origin = target.origin;
				}
			}
			if(isdefined(origin) && distance2dsquared(point.origin, origin) < (distance * distance))
			{
				tooclose = 1;
				break;
			}
		}
		if(tooclose)
		{
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = tooclosepenalty;
			#/
			point.score = point.score + tooclosepenalty;
		}
	}
}

/*
	Name: distancepointtoengagementheight
	Namespace: vehicle_ai
	Checksum: 0x1815BE84
	Offset: 0x6F28
	Size: 0x122
	Parameters: 4
	Flags: None
*/
function distancepointtoengagementheight(origin, enemy, engagementheightmin, engagementheightmax)
{
	if(!isdefined(enemy))
	{
		return undefined;
	}
	result = 0;
	engagementheight = 0.5 * (self.settings.engagementheightmin + self.settings.engagementheightmax);
	half_height = abs(engagementheightmax - engagementheight);
	targetheight = enemy.origin[2] + engagementheight;
	distfromengagementheight = abs(origin[2] - targetheight);
	if(distfromengagementheight > half_height)
	{
		result = distfromengagementheight - half_height;
	}
	return result;
}

/*
	Name: positionquery_filter_engagementheight
	Namespace: vehicle_ai
	Checksum: 0xBEA00DE8
	Offset: 0x7058
	Size: 0x186
	Parameters: 4
	Flags: Linked
*/
function positionquery_filter_engagementheight(queryresult, enemy, engagementheightmin, engagementheightmax)
{
	if(!isdefined(enemy))
	{
		return;
	}
	engagementheight = 0.5 * (engagementheightmin + engagementheightmax);
	half_height = abs(engagementheightmax - engagementheight);
	foreach(point in queryresult.data)
	{
		point.distengagementheight = 0;
		targetheight = enemy.origin[2] + engagementheight;
		distfromengagementheight = abs(point.origin[2] - targetheight);
		if(distfromengagementheight > half_height)
		{
			point.distengagementheight = distfromengagementheight - half_height;
		}
	}
}

/*
	Name: positionquery_postprocess_removeoutofgoalradius
	Namespace: vehicle_ai
	Checksum: 0x681EF66D
	Offset: 0x71E8
	Size: 0xBC
	Parameters: 2
	Flags: None
*/
function positionquery_postprocess_removeoutofgoalradius(queryresult, tolerance = 1)
{
	for(i = 0; i < queryresult.data.size; i++)
	{
		point = queryresult.data[i];
		if(point.disttogoal > tolerance)
		{
			arrayremoveindex(queryresult.data, i);
			i--;
		}
	}
}

/*
	Name: updatepersonalthreatbias_attackerlockedontome
	Namespace: vehicle_ai
	Checksum: 0xE4BA196B
	Offset: 0x72B0
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function updatepersonalthreatbias_attackerlockedontome(var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9)
{
	function_c8b0c8c2(self.locked_on, var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9);
}

/*
	Name: updatepersonalthreatbias_attackerlockingontome
	Namespace: vehicle_ai
	Checksum: 0xFB1493EA
	Offset: 0x7308
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function updatepersonalthreatbias_attackerlockingontome(var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9)
{
	function_c8b0c8c2(self.locking_on, var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9);
}

/*
	Name: function_c8b0c8c2
	Namespace: vehicle_ai
	Checksum: 0xBFCE0F29
	Offset: 0x7360
	Size: 0x188
	Parameters: 5
	Flags: Linked
*/
function function_c8b0c8c2(client_flags, var_9f84050f, var_1e08b2fd, var_9c5ca2c = 1, var_cee3c9e9 = 1)
{
	/#
		assert(isdefined(client_flags));
	#/
	remaining_flags_to_process = client_flags;
	for(i = 0; remaining_flags_to_process && i < level.players.size; i++)
	{
		attacker = level.players[i];
		if(isdefined(attacker))
		{
			client_flag = 1 << attacker getentitynumber();
			if(client_flag & remaining_flags_to_process)
			{
				self setpersonalthreatbias(attacker, int(var_9f84050f), var_1e08b2fd);
				if(var_9c5ca2c)
				{
					self getperfectinfo(attacker, var_cee3c9e9);
				}
				remaining_flags_to_process = remaining_flags_to_process & (~client_flag);
			}
		}
	}
}

/*
	Name: updatepersonalthreatbias_bots
	Namespace: vehicle_ai
	Checksum: 0x7E52AE37
	Offset: 0x74F0
	Size: 0xDA
	Parameters: 2
	Flags: None
*/
function updatepersonalthreatbias_bots(var_9f84050f, var_1e08b2fd)
{
	/#
		foreach(player in level.players)
		{
			if(player util::is_bot())
			{
				self setpersonalthreatbias(player, int(var_9f84050f), var_1e08b2fd);
			}
		}
	#/
}

/*
	Name: target_hijackers
	Namespace: vehicle_ai
	Checksum: 0x53C5153D
	Offset: 0x75D8
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function target_hijackers()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"ccom_lock_being_targeted", hijackingplayer);
		self getperfectinfo(hijackingplayer, 1);
		if(isplayer(hijackingplayer))
		{
			self setpersonalthreatbias(hijackingplayer, 1500, 4);
		}
	}
}

