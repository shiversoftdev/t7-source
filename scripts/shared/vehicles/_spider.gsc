// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace spider;

/*
	Name: __init__sytem__
	Namespace: spider
	Checksum: 0xFB465612
	Offset: 0x350
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spider", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spider
	Checksum: 0xAA565A33
	Offset: 0x390
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	vehicle::add_main_callback("spider", &spider_initialize);
	/#
		setdvar("", 0);
	#/
}

/*
	Name: no_switch_on
	Namespace: spider
	Checksum: 0x32AB2CBD
	Offset: 0x3E8
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function no_switch_on()
{
	return getdvarint("debug_spider_noswitch", 0) === 1;
}

/*
	Name: spider_initialize
	Namespace: spider
	Checksum: 0x1952E919
	Offset: 0x410
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function spider_initialize()
{
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.delete_on_death = 1;
	self.health = self.healthdefault;
	self useanimtree($generic);
	self vehicle::friendly_fire_shield();
	/#
		assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self enableaimassist();
	self setdrawinfrared(1);
	blackboard::createblackboardforentity(self);
	self blackboard::registervehicleblackboardattributes();
	self setneargoalnotifydist(40);
	self.goalradius = 999999;
	self.goalheight = 999999;
	self setgoal(self.origin, 0, self.goalradius, self.goalheight);
	self setontargetangle(3);
	self.overridevehicledamage = &spider_callback_damage;
	self thread vehicle_ai::nudge_collision();
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	self asmrequestsubstate("locomotion@movement");
	defaultrole();
}

/*
	Name: defaultrole
	Namespace: spider
	Checksum: 0x9B5F24ED
	Offset: 0x628
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function defaultrole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_range_combat_update;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::get_state_callbacks("driving").update_func = &state_driving_update;
	self vehicle_ai::add_state("meleeCombat", undefined, &state_melee_combat_update, undefined);
	vehicle_ai::add_utility_connection("combat", "meleeCombat", &should_switch_to_melee);
	vehicle_ai::add_utility_connection("meleeCombat", "combat", &should_switch_to_range);
	self vehicle_ai::call_custom_add_state_callbacks();
	vehicle_ai::startinitialstate("combat");
}

/*
	Name: state_death_update
	Namespace: spider
	Checksum: 0x61AFD353
	Offset: 0x7A0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function state_death_update(params)
{
	self endon(#"death");
	self asmrequestsubstate("death@stationary");
	vehicle_ai::waittill_asm_complete("death@stationary", 2);
	self vehicle_death::death_fx();
	vehicle_death::deletewhensafe(10);
}

/*
	Name: state_driving_update
	Namespace: spider
	Checksum: 0xDC28D17D
	Offset: 0x830
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function state_driving_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	self asmrequestsubstate("locomotion@aggressive");
}

/*
	Name: getnextmoveposition_ranged
	Namespace: spider
	Checksum: 0x69692A0
	Offset: 0x878
	Size: 0x652
	Parameters: 1
	Flags: Linked
*/
function getnextmoveposition_ranged(enemy)
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	selfdisttotarget = distance2d(self.origin, enemy.origin);
	gooddist = 0.5 * (self.settings.engagementdistmin + self.settings.engagementdistmax);
	tooclosedist = 150;
	closedist = 1.2 * gooddist;
	fardist = 3 * gooddist;
	querymultiplier = mapfloat(closedist, fardist, 1, 3, selfdisttotarget);
	prefereddistawayfromorigin = 300;
	randomness = 30;
	queryresult = positionquery_source_navigation(self.origin, 80, 300 * querymultiplier, 150, (2 * self.radius) * querymultiplier, self, (1 * self.radius) * querymultiplier);
	positionquery_filter_distancetogoal(queryresult, self);
	vehicle_ai::positionquery_filter_outofgoalanchor(queryresult);
	positionquery_filter_inclaimedlocation(queryresult, self);
	vehicle_ai::positionquery_filter_engagementdist(queryresult, enemy, self.settings.engagementdistmin, self.settings.engagementdistmax);
	if(isdefined(self.avoidentities) && isdefined(self.avoidentitiesdistance))
	{
		vehicle_ai::positionquery_filter_distawayfromtarget(queryresult, self.avoidentities, self.avoidentitiesdistance, -500);
	}
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryresult.data)
	{
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = mapfloat(0, prefereddistawayfromorigin, 0, 300, point.disttoorigin2d);
		#/
		point.score = point.score + mapfloat(0, prefereddistawayfromorigin, 0, 300, point.disttoorigin2d);
		if(point.inclaimedlocation)
		{
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = -500;
			#/
			point.score = point.score + -500;
		}
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = randomfloatrange(0, randomness);
		#/
		point.score = point.score + randomfloatrange(0, randomness);
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = point.distawayfromengagementarea * -1;
		#/
		point.score = point.score + (point.distawayfromengagementarea * -1);
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::positionquery_debugscores(queryresult);
	/#
		self.debug_ai_move_to_points_considered = queryresult.data;
	#/
	if(!isdefined(best_point))
	{
		return undefined;
	}
	/#
		if(isdefined(getdvarint("")) && getdvarint(""))
		{
			recordline(self.origin, best_point.origin, (0.3, 1, 0));
			recordline(self.origin, enemy.origin, (1, 0, 0.4));
		}
	#/
	return best_point.origin;
}

/*
	Name: state_range_combat_update
	Namespace: spider
	Checksum: 0xE0FACE9A
	Offset: 0xED8
	Size: 0x2A8
	Parameters: 1
	Flags: Linked
*/
function state_range_combat_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	self.pathfailcount = 0;
	self.foundpath = 1;
	if(params.playtransition === 1)
	{
		self vehicle_ai::clearallmovement(1);
		self asmrequestsubstate("exit@aggressive");
		self vehicle_ai::waittill_asm_complete("exit@aggressive", 1.6);
	}
	self vehicle_ai::cooldown("state_change", 15);
	self thread prevent_stuck();
	self thread nudge_collision();
	self thread state_range_combat_attack();
	self setspeed(self.settings.defaultmovespeed);
	self asmrequestsubstate("locomotion@movement");
	self.dont_move = undefined;
	for(;;)
	{
		if(!isdefined(self.enemy))
		{
			self force_get_enemies();
			wait(0.1);
			continue;
		}
		else if(self.dont_move === 1)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self.can_reach_enemy))
		{
			if(!self [[self.can_reach_enemy]]())
			{
				wait(0.1);
				continue;
			}
		}
		if(!self vehseenrecently(self.enemy, 5))
		{
			self.current_pathto_pos = spider_get_target_position();
		}
		else
		{
			self.current_pathto_pos = getnextmoveposition_ranged(self.enemy);
		}
		if(isdefined(self.current_pathto_pos))
		{
			if(self setvehgoalpos(self.current_pathto_pos, 0, 1))
			{
				self vehicle_ai::waittill_pathing_done();
			}
		}
		wait(0.05);
	}
}

/*
	Name: state_range_combat_attack
	Namespace: spider
	Checksum: 0xD6EFBA40
	Offset: 0x1188
	Size: 0x2C8
	Parameters: 0
	Flags: Linked
*/
function state_range_combat_attack()
{
	self endon(#"change_state");
	self endon(#"death");
	for(;;)
	{
		if(!isdefined(self.enemy))
		{
			wait(0.1);
			continue;
		}
		state_params = spawnstruct();
		state_params.playtransition = 1;
		self vehicle_ai::evaluate_connections(undefined, state_params);
		can_attack = 1;
		foreach(player in level.players)
		{
			self getperfectinfo(player, 0);
			if(player.b_is_designated_target === 1 && self.enemy.b_is_designated_target !== 1)
			{
				self getperfectinfo(player, 1);
				self setpersonalthreatbias(player, 100000, 2);
				can_attack = 0;
			}
		}
		if(can_attack)
		{
			if(self vehcansee(self.enemy))
			{
				self setlookatent(self.enemy);
				self setturrettargetent(self.enemy);
			}
			if(distance2dsquared(self.origin, self.enemy.origin) < (self.settings.engagementdistmax * 1.5) * (self.settings.engagementdistmax * 1.5) && vehicle_ai::iscooldownready("rocket") && self vehcansee(self.enemy))
			{
				self do_ranged_attack(self.enemy);
				wait(0.5);
			}
		}
		wait(0.1);
	}
}

/*
	Name: do_ranged_attack
	Namespace: spider
	Checksum: 0x35ACDA79
	Offset: 0x1458
	Size: 0x2CE
	Parameters: 1
	Flags: Linked
*/
function do_ranged_attack(enemy)
{
	self notify(#"near_goal");
	self vehicle_ai::clearallmovement(1);
	self.dont_move = 1;
	self setlookatent(enemy);
	self setturrettargetent(enemy);
	self setvehgoalpos(enemy.origin, 0, 0);
	targetanglediff = 30;
	v_to_enemy = (enemy.origin - self.origin[0], enemy.origin - self.origin[1], 0);
	goalangles = vectortoangles(v_to_enemy);
	anglediff = absangleclamp180(self.angles[1] - goalangles[1]);
	angleadjustingstart = gettime();
	while(anglediff > targetanglediff && vehicle_ai::timesince(angleadjustingstart) < 0.8)
	{
		anglediff = absangleclamp180(self.angles[1] - goalangles[1]);
		wait(0.05);
	}
	self vehicle_ai::clearallmovement(1);
	if(anglediff <= targetanglediff)
	{
		self asmrequestsubstate("fire@stationary");
		timedout = self util::waittill_notify_or_timeout("spider_fire", 5);
		if(timedout !== 1)
		{
			self fireweapon();
			self vehicle_ai::cooldown("rocket", 3);
			self vehicle_ai::waittill_asm_complete("fire@stationary", 5);
		}
	}
	self asmrequestsubstate("locomotion@movement");
	self.dont_move = undefined;
}

/*
	Name: switch_to_melee
	Namespace: spider
	Checksum: 0xD491A878
	Offset: 0x1730
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function switch_to_melee()
{
	self.switch_to_melee = 1;
}

/*
	Name: should_switch_to_melee
	Namespace: spider
	Checksum: 0xEEF46B8B
	Offset: 0x1748
	Size: 0x118
	Parameters: 3
	Flags: Linked
*/
function should_switch_to_melee(from_state, to_state, connection)
{
	/#
		if(no_switch_on())
		{
			return false;
		}
	#/
	if(!vehicle_ai::iscooldownready("state_change"))
	{
		return false;
	}
	if(!isdefined(self.enemy))
	{
		return false;
	}
	if(self.switch_to_melee === 1 || (distance2dsquared(self.origin, self.enemy.origin) < (self.settings.meleedist * self.settings.meleedist) && (abs(self.origin[2] - self.enemy.origin[2])) < self.settings.meleedist))
	{
		return true;
	}
	return false;
}

/*
	Name: state_melee_combat_update
	Namespace: spider
	Checksum: 0x3983F88B
	Offset: 0x1868
	Size: 0x8FC
	Parameters: 1
	Flags: Linked
*/
function state_melee_combat_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	if(params.playtransition === 1)
	{
		self vehicle_ai::clearallmovement(1);
		self asmrequestsubstate("enter@aggressive");
		self vehicle_ai::waittill_asm_complete("enter@aggressive", 1.6);
	}
	self vehicle_ai::cooldown("state_change", 8);
	self thread prevent_stuck();
	self thread nudge_collision();
	self thread state_melee_combat_attack();
	self.pathfailcount = 0;
	self.switch_to_melee = undefined;
	self setspeed(self.settings.defaultmovespeed * 1.5);
	self asmrequestsubstate("locomotion@aggressive");
	self.dont_move = undefined;
	wait(0.5);
	for(;;)
	{
		foreach(player in level.players)
		{
			self getperfectinfo(player, 1);
			if(player.b_is_designated_target === 1)
			{
				self setpersonalthreatbias(player, 100000, 3);
			}
		}
		if(!isdefined(self.enemy))
		{
			self force_get_enemies();
			wait(0.1);
			continue;
		}
		else if(self.dont_move === 1)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self.can_reach_enemy))
		{
			if(!self [[self.can_reach_enemy]]())
			{
				wait(0.1);
				continue;
			}
		}
		self.foundpath = 0;
		targetpos = spider_get_target_position();
		if(isdefined(targetpos))
		{
			if(distancesquared(self.origin, targetpos) > (1000 * 1000) && self isposinclaimedlocation(targetpos))
			{
				queryresult = positionquery_source_navigation(targetpos, 0, self.settings.max_move_dist, self.settings.max_move_dist, self.radius, self);
				positionquery_filter_inclaimedlocation(queryresult, self.enemy);
				best_point = undefined;
				best_score = -999999;
				foreach(point in queryresult.data)
				{
					/#
						if(!isdefined(point._scoredebug))
						{
							point._scoredebug = [];
						}
						point._scoredebug[""] = mapfloat(0, 200, 0, -200, distance(point.origin, queryresult.origin));
					#/
					point.score = point.score + (mapfloat(0, 200, 0, -200, distance(point.origin, queryresult.origin)));
					/#
						if(!isdefined(point._scoredebug))
						{
							point._scoredebug = [];
						}
						point._scoredebug[""] = mapfloat(50, 200, 0, -200, abs(point.origin[2] - queryresult.origin[2]));
					#/
					point.score = point.score + (mapfloat(50, 200, 0, -200, abs(point.origin[2] - queryresult.origin[2])));
					if(point.inclaimedlocation === 1)
					{
						/#
							if(!isdefined(point._scoredebug))
							{
								point._scoredebug = [];
							}
							point._scoredebug[""] = -500;
						#/
						point.score = point.score + -500;
					}
					if(point.score > best_score)
					{
						best_score = point.score;
						best_point = point;
					}
				}
				self vehicle_ai::positionquery_debugscores(queryresult);
				if(isdefined(best_point))
				{
					targetpos = best_point.origin;
				}
			}
			self setvehgoalpos(targetpos, 0, 1);
			self.foundpath = self vehicle_ai::waittill_pathresult();
			if(self.foundpath)
			{
				self.current_pathto_pos = targetpos;
				self thread path_update_interrupt_melee();
				self.pathfailcount = 0;
				self vehicle_ai::waittill_pathing_done();
			}
		}
		if(!self.foundpath)
		{
			self.pathfailcount++;
			if(self.pathfailcount > 2)
			{
				if(isdefined(self.enemy))
				{
					self setpersonalthreatbias(self.enemy, -2000, 5);
				}
			}
			wait(0.1);
			queryresult = positionquery_source_navigation(self.origin, 0, self.settings.max_move_dist, self.settings.max_move_dist, self.radius, self);
			if(queryresult.data.size)
			{
				point = queryresult.data[randomint(queryresult.data.size)];
				self setvehgoalpos(point.origin, 0, 0);
				self.current_pathto_pos = undefined;
				self thread path_update_interrupt_melee();
				wait(2);
				self notify(#"near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: state_melee_combat_attack
	Namespace: spider
	Checksum: 0xADCEEDE5
	Offset: 0x2170
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function state_melee_combat_attack()
{
	self endon(#"change_state");
	self endon(#"death");
	for(;;)
	{
		state_params = spawnstruct();
		state_params.playtransition = 1;
		if(!isdefined(self.enemy))
		{
			wait(0.1);
			self vehicle_ai::evaluate_connections(undefined, state_params);
			continue;
		}
		self vehicle_ai::evaluate_connections(undefined, state_params);
		if(self vehcansee(self.enemy))
		{
			self setlookatent(self.enemy);
			self setturrettargetent(self.enemy);
		}
		if(distance2dsquared(self.origin, self.enemy.origin) < (self.settings.meleereach * self.settings.meleereach) && self vehcansee(self.enemy))
		{
			if(bullettracepassed(self.origin + vectorscale((0, 0, 1), 10), self.enemy.origin + vectorscale((0, 0, 1), 20), 0, self, self.enemy, 0, 1))
			{
				self do_melee_attack(self.enemy);
				wait(0.5);
			}
		}
		wait(0.1);
	}
}

/*
	Name: do_melee_attack
	Namespace: spider
	Checksum: 0xEC940C78
	Offset: 0x2370
	Size: 0x186
	Parameters: 1
	Flags: Linked
*/
function do_melee_attack(enemy)
{
	self notify(#"near_goal");
	self vehicle_ai::clearallmovement(1);
	self.dont_move = 1;
	self asmrequestsubstate("melee@stationary");
	timedout = self util::waittill_notify_or_timeout("spider_melee", 3);
	if(timedout !== 1)
	{
		if(isalive(enemy) && distance2dsquared(self.origin, enemy.origin) < (self.settings.meleereach * 1.2) * (self.settings.meleereach * 1.2))
		{
			enemy dodamage(self.settings.meleedamage, self.origin, self, self);
		}
		self vehicle_ai::waittill_asm_complete("melee@stationary", 2);
	}
	self asmrequestsubstate("locomotion@aggressive");
	self.dont_move = undefined;
}

/*
	Name: should_switch_to_range
	Namespace: spider
	Checksum: 0x923EA3B9
	Offset: 0x2500
	Size: 0x100
	Parameters: 3
	Flags: Linked
*/
function should_switch_to_range(from_state, to_state, connection)
{
	/#
		if(no_switch_on())
		{
			return false;
		}
	#/
	if(self.pathfailcount > 4)
	{
		return true;
	}
	if(!vehicle_ai::iscooldownready("state_change"))
	{
		return false;
	}
	if(isalive(self.enemy) && distance2dsquared(self.origin, self.enemy.origin) > (self.settings.meleedist * 4) * (self.settings.meleedist * 4))
	{
		return true;
	}
	if(!isdefined(self.enemy))
	{
		return true;
	}
	return false;
}

/*
	Name: prevent_stuck
	Namespace: spider
	Checksum: 0xCFA6C105
	Offset: 0x2608
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function prevent_stuck()
{
	self endon(#"change_state");
	self endon(#"death");
	self notify(#"end_prevent_stuck");
	self endon(#"end_prevent_stuck");
	wait(2);
	count = 0;
	previous_origin = undefined;
	while(true)
	{
		if(isdefined(previous_origin) && distancesquared(previous_origin, self.origin) < (0.1 * 0.1) && (!(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)))
		{
			count++;
		}
		else
		{
			previous_origin = self.origin;
			count = 0;
		}
		if(count > 10)
		{
			self.pathfailcount = 10;
		}
		wait(1);
	}
}

/*
	Name: spider_get_target_position
	Namespace: spider
	Checksum: 0xB8164971
	Offset: 0x2710
	Size: 0x376
	Parameters: 0
	Flags: Linked
*/
function spider_get_target_position()
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	if(isdefined(self.settings.all_knowing))
	{
		if(isdefined(self.enemy))
		{
			target_pos = self.enemy.origin;
		}
	}
	else
	{
		target_pos = vehicle_ai::gettargetpos(vehicle_ai::getenemytarget());
	}
	enemy = self.enemy;
	if(isdefined(target_pos))
	{
		target_pos_onnavmesh = getclosestpointonnavmesh(target_pos, self.settings.detonation_distance * 1.5, self.radius, 16777183);
	}
	if(!isdefined(target_pos_onnavmesh))
	{
		if(isdefined(self.enemy))
		{
			self setpersonalthreatbias(self.enemy, -2000, 5);
		}
		if(isdefined(self.current_pathto_pos) && distancesquared(self.origin, self.current_pathto_pos) > (self.settings.meleereach * self.settings.meleereach))
		{
			return self.current_pathto_pos;
		}
		return undefined;
	}
	if(isdefined(self.enemy))
	{
		if(distancesquared(target_pos, target_pos_onnavmesh) > (self.settings.detonation_distance * 0.9) * (self.settings.detonation_distance * 0.9))
		{
			self setpersonalthreatbias(self.enemy, -2000, 5);
		}
	}
	if(isdefined(enemy) && isplayer(enemy))
	{
		enemy_vel_offset = enemy getvelocity() * 0.5;
		enemy_look_dir_offset = anglestoforward(enemy.angles);
		if(distance2dsquared(self.origin, enemy.origin) > (500 * 500))
		{
			enemy_look_dir_offset = enemy_look_dir_offset * 110;
		}
		else
		{
			enemy_look_dir_offset = enemy_look_dir_offset * 35;
		}
		offset = enemy_vel_offset + enemy_look_dir_offset;
		offset = (offset[0], offset[1], 0);
		if(tracepassedonnavmesh(target_pos_onnavmesh, target_pos + offset))
		{
			target_pos = target_pos + offset;
		}
		else
		{
			target_pos = target_pos_onnavmesh;
		}
	}
	else
	{
		target_pos = target_pos_onnavmesh;
	}
	return target_pos;
}

/*
	Name: path_update_interrupt_melee
	Namespace: spider
	Checksum: 0x18AF3342
	Offset: 0x2A90
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function path_update_interrupt_melee()
{
	self endon(#"death");
	self endon(#"change_state");
	self endon(#"near_goal");
	self endon(#"reached_end_node");
	self notify(#"clear_interrupt_threads");
	self endon(#"clear_interrupt_threads");
	wait(0.1);
	while(true)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(distance2dsquared(self.current_pathto_pos, self.goalpos) > (self.goalradius * self.goalradius))
			{
				wait(0.5);
				self notify(#"near_goal");
			}
			targetpos = spider_get_target_position();
			if(isdefined(targetpos))
			{
				if(distancesquared(self.origin, targetpos) > (1000 * 1000))
				{
					repath_range = self.settings.repath_range * 2;
					wait(0.1);
				}
				else
				{
					repath_range = self.settings.repath_range;
				}
				if(distance2dsquared(self.current_pathto_pos, targetpos) > (repath_range * repath_range))
				{
					self notify(#"near_goal");
				}
			}
			if(isdefined(self.enemy) && isplayer(self.enemy))
			{
				forward = anglestoforward(self.enemy getplayerangles());
				dir_to_raps = self.origin - self.enemy.origin;
				speedtouse = self.settings.defaultmovespeed * 2;
				if(vectordot(forward, dir_to_raps) > 0)
				{
					self setspeed(speedtouse);
				}
				else
				{
					self setspeed(speedtouse * 0.75);
				}
			}
			else
			{
				speedtouse = self.settings.defaultmovespeed * 2;
				self setspeed(speedtouse);
			}
			wait(0.2);
		}
		else
		{
			wait(0.4);
		}
	}
}

/*
	Name: nudge_collision
	Namespace: spider
	Checksum: 0xB9B69B7C
	Offset: 0x2D80
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function nudge_collision()
{
	self endon(#"death");
	self endon(#"change_state");
	self notify(#"end_nudge_collision");
	self endon(#"end_nudge_collision");
	while(true)
	{
		self waittill(#"veh_collision", velocity, normal);
		ang_vel = self getangularvelocity() * 0.8;
		self setangularvelocity(ang_vel);
		if(isalive(self) && vectordot(normal, (0, 0, 1)) < 0.5)
		{
			self setvehvelocity(self.velocity + (normal * 400));
		}
	}
}

/*
	Name: force_get_enemies
	Namespace: spider
	Checksum: 0xB66F8F33
	Offset: 0x2EA0
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function force_get_enemies()
{
	foreach(player in level.players)
	{
		if(self util::isenemyplayer(player) && !player.ignoreme)
		{
			self getperfectinfo(player, 1);
			return;
		}
	}
}

/*
	Name: spider_callback_damage
	Namespace: spider
	Checksum: 0xCA469211
	Offset: 0x2F68
	Size: 0xB8
	Parameters: 15
	Flags: Linked
*/
function spider_callback_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(isalive(eattacker) && eattacker.team === self.team)
	{
		return 0;
	}
	return idamage;
}

