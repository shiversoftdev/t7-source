// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace parasite;

/*
	Name: __init__sytem__
	Namespace: parasite
	Checksum: 0x5E487077
	Offset: 0x480
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("parasite", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: parasite
	Checksum: 0x68CC67BE
	Offset: 0x4C0
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	vehicle::add_main_callback("parasite", &parasite_initialize);
	clientfield::register("vehicle", "parasite_tell_fx", 1, 1, "int");
	clientfield::register("vehicle", "parasite_secondary_deathfx", 1, 1, "int");
	clientfield::register("toplayer", "parasite_damage", 1, 1, "counter");
	callback::on_spawned(&parasite_damage);
	ai::registermatchedinterface("parasite", "firing_rate", "slow", array("slow", "medium", "fast"));
}

/*
	Name: parasite_damage
	Namespace: parasite
	Checksum: 0x9B4FF9FC
	Offset: 0x5F8
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function parasite_damage()
{
	self notify(#"parasite_damage_thread");
	self endon(#"parasite_damage_thread");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", n_ammount, e_attacker);
		if(isdefined(e_attacker) && (isdefined(e_attacker.is_parasite) && e_attacker.is_parasite) && (!(isdefined(e_attacker.squelch_damage_overlay) && e_attacker.squelch_damage_overlay)))
		{
			self clientfield::increment_to_player("parasite_damage");
		}
	}
}

/*
	Name: is_target_valid
	Namespace: parasite
	Checksum: 0xA9E4AAC1
	Offset: 0x6D0
	Size: 0x118
	Parameters: 1
	Flags: Linked, Private
*/
function private is_target_valid(target)
{
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	if(isplayer(target) && target.sessionstate == "spectator")
	{
		return 0;
	}
	if(isplayer(target) && target.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(target.ignoreme) && target.ignoreme)
	{
		return 0;
	}
	if(target isnotarget())
	{
		return 0;
	}
	if(isdefined(self.is_target_valid_cb))
	{
		return self [[self.is_target_valid_cb]](target);
	}
	return 1;
}

/*
	Name: get_parasite_enemy
	Namespace: parasite
	Checksum: 0xE03E2B16
	Offset: 0x7F0
	Size: 0x13A
	Parameters: 0
	Flags: Linked
*/
function get_parasite_enemy()
{
	parasite_targets = getplayers();
	least_hunted = parasite_targets[0];
	for(i = 0; i < parasite_targets.size; i++)
	{
		if(!isdefined(parasite_targets[i].hunted_by))
		{
			parasite_targets[i].hunted_by = 0;
		}
		if(!is_target_valid(parasite_targets[i]))
		{
			continue;
		}
		if(!is_target_valid(least_hunted))
		{
			least_hunted = parasite_targets[i];
		}
		if(parasite_targets[i].hunted_by < least_hunted.hunted_by)
		{
			least_hunted = parasite_targets[i];
		}
	}
	if(!is_target_valid(least_hunted))
	{
		return undefined;
	}
	return least_hunted;
}

/*
	Name: set_parasite_enemy
	Namespace: parasite
	Checksum: 0x65ED600E
	Offset: 0x938
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function set_parasite_enemy(enemy)
{
	if(!is_target_valid(enemy))
	{
		return;
	}
	if(isdefined(self.parasiteenemy))
	{
		if(!isdefined(self.parasiteenemy.hunted_by))
		{
			self.parasiteenemy.hunted_by = 0;
		}
		if(self.parasiteenemy.hunted_by > 0)
		{
			self.parasiteenemy.hunted_by--;
		}
	}
	self.parasiteenemy = enemy;
	if(!isdefined(self.parasiteenemy.hunted_by))
	{
		self.parasiteenemy.hunted_by = 0;
	}
	self.parasiteenemy.hunted_by++;
	self setlookatent(self.parasiteenemy);
	self setturrettargetent(self.parasiteenemy);
}

/*
	Name: parasite_target_selection
	Namespace: parasite
	Checksum: 0x30175CB4
	Offset: 0xA48
	Size: 0x118
	Parameters: 0
	Flags: Linked, Private
*/
function private parasite_target_selection()
{
	self endon(#"change_state");
	self endon(#"death");
	for(;;)
	{
		if(isdefined(self.ignoreall) && self.ignoreall)
		{
			wait(0.5);
			continue;
		}
		if(is_target_valid(self.parasiteenemy))
		{
			wait(0.5);
			continue;
		}
		target = get_parasite_enemy();
		if(!isdefined(target))
		{
			self.parasiteenemy = undefined;
		}
		else
		{
			self.parasiteenemy = target;
			self.parasiteenemy.hunted_by = self.parasiteenemy.hunted_by + 1;
			self setlookatent(self.parasiteenemy);
			self setturrettargetent(self.parasiteenemy);
		}
		wait(0.5);
	}
}

/*
	Name: parasite_initialize
	Namespace: parasite
	Checksum: 0x7AA832E2
	Offset: 0xB68
	Size: 0x24C
	Parameters: 0
	Flags: Linked
*/
function parasite_initialize()
{
	self useanimtree($generic);
	blackboard::createblackboardforentity(self);
	self blackboard::registervehicleblackboardattributes();
	ai::createinterfaceforentity(self);
	blackboard::registerblackboardattribute(self, "_parasite_firing_rate", "slow", &getparasitefiringrate);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self enableaimassist();
	self setneargoalnotifydist(25);
	self setdrawinfrared(1);
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.vehaircraftcollisionenabled = 1;
	/#
		assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalradius = 999999;
	self.goalheight = 4000;
	self setgoal(self.origin, 0, self.goalradius, self.goalheight);
	self.is_parasite = 1;
	self thread vehicle_ai::nudge_collision();
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	defaultrole();
}

/*
	Name: defaultrole
	Namespace: parasite
	Checksum: 0x62C42A9D
	Offset: 0xDC0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function defaultrole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").enter_func = &state_combat_enter;
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::call_custom_add_state_callbacks();
	vehicle_ai::startinitialstate("combat");
}

/*
	Name: getparasitefiringrate
	Namespace: parasite
	Checksum: 0xBD541FA4
	Offset: 0xEB0
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function getparasitefiringrate()
{
	return self ai::get_behavior_attribute("firing_rate");
}

/*
	Name: state_death_update
	Namespace: parasite
	Checksum: 0x6284F85C
	Offset: 0xEE0
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function state_death_update(params)
{
	self endon(#"death");
	self asmrequestsubstate("death@stationary");
	if(isdefined(self.parasiteenemy) && isdefined(self.parasiteenemy.hunted_by))
	{
		self.parasiteenemy.hunted_by--;
	}
	self setphysacceleration(vectorscale((0, 0, -1), 300));
	self.vehcheckforpredictedcrash = 1;
	self thread vehicle_death::death_fx();
	self playsound("zmb_parasite_explo");
	self util::waittill_notify_or_timeout("veh_predictedcollision", 4);
	self clientfield::set("parasite_secondary_deathfx", 1);
	wait(0.2);
	self delete();
}

/*
	Name: state_combat_enter
	Namespace: parasite
	Checksum: 0x5DD13A44
	Offset: 0x1018
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function state_combat_enter(params)
{
	if(isdefined(self.owner) && isdefined(self.owner.enemy))
	{
		self.parasiteenemy = self.owner.enemy;
	}
	self thread parasite_target_selection();
}

/*
	Name: state_combat_update
	Namespace: parasite
	Checksum: 0x3E2505C
	Offset: 0x1080
	Size: 0x480
	Parameters: 1
	Flags: Linked
*/
function state_combat_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	lasttimechangeposition = 0;
	self.shouldgotonewposition = 0;
	self.lasttimetargetinsight = 0;
	self.lasttimejuked = 0;
	self asmrequestsubstate("locomotion@movement");
	for(;;)
	{
		if(isdefined(self._override_parasite_combat_speed))
		{
			self setspeed(self._override_parasite_combat_speed);
		}
		else
		{
			self setspeed(self.settings.defaultmovespeed);
		}
		if(isdefined(self.inpain) && self.inpain)
		{
			wait(0.1);
			continue;
		}
		if(!isdefined(self.parasiteenemy))
		{
			wait(0.25);
			continue;
		}
		if(self.goalforced)
		{
			returndata = [];
			returndata["origin"] = self getclosestpointonnavvolume(self.goalpos, 100);
			returndata["centerOnNav"] = ispointinnavvolume(self.origin, "navvolume_small");
		}
		else
		{
			if(randomint(100) < self.settings.jukeprobability && (!(isdefined(self.lasttimejuked) && self.lasttimejuked)) || (isdefined(self._override_juke) && self._override_juke))
			{
				returndata = getnextmoveposition_forwardjuke();
				self.lasttimejuked = 1;
				self._override_juke = undefined;
			}
			else
			{
				returndata = getnextmoveposition_tactical();
				self.lasttimejuked = 0;
			}
		}
		self.current_pathto_pos = returndata["origin"];
		if(isdefined(self.current_pathto_pos))
		{
			if(isdefined(self.stucktime))
			{
				self.stucktime = undefined;
			}
			if(self setvehgoalpos(self.current_pathto_pos, 1, returndata["centerOnNav"]))
			{
				self thread path_update_interrupt();
				self playsound("zmb_vocals_parasite_juke");
				self vehicle_ai::waittill_pathing_done(5);
			}
			else
			{
				wait(0.1);
			}
		}
		else if(!(isdefined(returndata["centerOnNav"]) && returndata["centerOnNav"]))
		{
			if(!isdefined(self.stucktime))
			{
				self.stucktime = gettime();
			}
			if((gettime() - self.stucktime) > 10000)
			{
				self dodamage(self.health + 100, self.origin);
			}
		}
		if(isdefined(self.lasttimejuked) && self.lasttimejuked)
		{
			if(randomint(100) < 50 && isdefined(self.parasiteenemy) && distance2dsquared(self.origin, self.parasiteenemy.origin) < (64 * 64))
			{
				self.parasiteenemy dodamage(self.settings.meleedamage, self.parasiteenemy.origin, self);
			}
			else
			{
				self fire_pod_logic(self.lasttimejuked);
			}
			continue;
		}
		if(randomint(100) < 30)
		{
			self fire_pod_logic(self.lasttimejuked);
		}
	}
}

/*
	Name: fire_pod_logic
	Namespace: parasite
	Checksum: 0x6D287E87
	Offset: 0x1508
	Size: 0x2CC
	Parameters: 1
	Flags: Linked
*/
function fire_pod_logic(chosetojuke)
{
	if(isdefined(self.parasiteenemy) && self vehcansee(self.parasiteenemy) && distance2dsquared(self.parasiteenemy.origin, self.origin) < ((0.5 * (self.settings.engagementdistmin + self.settings.engagementdistmax)) * 3) * ((0.5 * (self.settings.engagementdistmin + self.settings.engagementdistmax)) * 3))
	{
		self asmrequestsubstate("fire@stationary");
		self playsound("zmb_vocals_parasite_preattack");
		self clientfield::set("parasite_tell_fx", 1);
		self waittill(#"pre_fire");
		if(isdefined(self.parasiteenemy) && self vehcansee(self.parasiteenemy) && distance2dsquared(self.parasiteenemy.origin, self.origin) < ((0.5 * (self.settings.engagementdistmin + self.settings.engagementdistmax)) * 3) * ((0.5 * (self.settings.engagementdistmin + self.settings.engagementdistmax)) * 3))
		{
			self setturrettargetent(self.parasiteenemy, self.parasiteenemy getvelocity() * 0.3);
		}
		self vehicle_ai::waittill_asm_complete("fire@stationary", 5);
		self asmrequestsubstate("locomotion@movement");
		self clientfield::set("parasite_tell_fx", 0);
		if(!chosetojuke)
		{
			wait(randomfloatrange(0.25, 0.5));
		}
	}
	else
	{
		wait(randomfloatrange(1, 2));
	}
}

/*
	Name: getnextmoveposition_tactical
	Namespace: parasite
	Checksum: 0x943DFA33
	Offset: 0x17E0
	Size: 0x72E
	Parameters: 0
	Flags: Linked
*/
function getnextmoveposition_tactical()
{
	self endon(#"change_state");
	self endon(#"death");
	selfdisttotarget = distance2d(self.origin, self.parasiteenemy.origin);
	gooddist = 0.5 * (self.settings.engagementdistmin + self.settings.engagementdistmax);
	closedist = 1.2 * gooddist;
	fardist = 3 * gooddist;
	querymultiplier = mapfloat(closedist, fardist, 1, 3, selfdisttotarget);
	preferedheightrange = 0.5 * (self.settings.engagementheightmax - self.settings.engagementheightmin);
	randomness = 30;
	queryresult = positionquery_source_navigation(self.origin, 75, 225 * querymultiplier, 75, 20 * querymultiplier, self, 20 * querymultiplier);
	if(!(isdefined(queryresult.centeronnav) && queryresult.centeronnav))
	{
		self.vehaircraftcollisionenabled = 0;
	}
	else
	{
		self.vehaircraftcollisionenabled = 1;
	}
	positionquery_filter_distancetogoal(queryresult, self);
	vehicle_ai::positionquery_filter_outofgoalanchor(queryresult);
	self vehicle_ai::positionquery_filter_engagementdist(queryresult, self.parasiteenemy, self.settings.engagementdistmin, self.settings.engagementdistmax);
	goalheight = self.parasiteenemy.origin[2] + (0.5 * (self.settings.engagementheightmin + self.settings.engagementheightmax));
	best_point = undefined;
	best_score = -999999;
	trace_count = 0;
	foreach(point in queryresult.data)
	{
		if(!(isdefined(queryresult.centeronnav) && queryresult.centeronnav))
		{
			if(sighttracepassed(self.origin, point.origin, 0, undefined))
			{
				trace_count++;
				if(trace_count > 3)
				{
					wait(0.05);
					trace_count = 0;
				}
				if(!bullettracepassed(self.origin, point.origin, 0, self))
				{
					continue;
				}
			}
			else
			{
				continue;
			}
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
		distfrompreferredheight = abs(point.origin[2] - goalheight);
		if(distfrompreferredheight > preferedheightrange)
		{
			heightscore = mapfloat(0, 500, 0, 2000, distfrompreferredheight);
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = heightscore * -1;
			#/
			point.score = point.score + (heightscore * -1);
		}
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::positionquery_debugscores(queryresult);
	/#
		if(isdefined(getdvarint("")) && getdvarint(""))
		{
			recordline(self.origin, best_point.origin, (0.3, 1, 0));
			recordline(self.origin, self.parasiteenemy.origin, (1, 0, 0.4));
		}
	#/
	returndata = [];
	returndata["origin"] = (isdefined(best_point) ? best_point.origin : undefined);
	returndata["centerOnNav"] = queryresult.centeronnav;
	return returndata;
}

/*
	Name: getnextmoveposition_forwardjuke
	Namespace: parasite
	Checksum: 0x6E44752
	Offset: 0x1F18
	Size: 0x72E
	Parameters: 0
	Flags: Linked
*/
function getnextmoveposition_forwardjuke()
{
	self endon(#"change_state");
	self endon(#"death");
	selfdisttotarget = distance2d(self.origin, self.parasiteenemy.origin);
	gooddist = 0.5 * (self.settings.forwardjukeengagementdistmin + self.settings.forwardjukeengagementdistmax);
	closedist = 1.2 * gooddist;
	fardist = 3 * gooddist;
	querymultiplier = mapfloat(closedist, fardist, 1, 3, selfdisttotarget);
	preferedheightrange = 0.5 * (self.settings.forwardjukeengagementheightmax - self.settings.forwardjukeengagementheightmin);
	randomness = 30;
	queryresult = positionquery_source_navigation(self.origin, 75, 300 * querymultiplier, 75, 20 * querymultiplier, self, 20 * querymultiplier);
	if(!(isdefined(queryresult.centeronnav) && queryresult.centeronnav))
	{
		self.vehaircraftcollisionenabled = 0;
	}
	else
	{
		self.vehaircraftcollisionenabled = 1;
	}
	positionquery_filter_distancetogoal(queryresult, self);
	vehicle_ai::positionquery_filter_outofgoalanchor(queryresult);
	self vehicle_ai::positionquery_filter_engagementdist(queryresult, self.parasiteenemy, self.settings.forwardjukeengagementdistmin, self.settings.forwardjukeengagementdistmax);
	goalheight = self.parasiteenemy.origin[2] + (0.5 * (self.settings.forwardjukeengagementheightmin + self.settings.forwardjukeengagementheightmax));
	best_point = undefined;
	best_score = -999999;
	trace_count = 0;
	foreach(point in queryresult.data)
	{
		if(!(isdefined(queryresult.centeronnav) && queryresult.centeronnav))
		{
			if(sighttracepassed(self.origin, point.origin, 0, undefined))
			{
				trace_count++;
				if(trace_count > 3)
				{
					wait(0.05);
					trace_count = 0;
				}
				if(!bullettracepassed(self.origin, point.origin, 0, self))
				{
					continue;
				}
			}
			else
			{
				continue;
			}
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
		distfrompreferredheight = abs(point.origin[2] - goalheight);
		if(distfrompreferredheight > preferedheightrange)
		{
			heightscore = mapfloat(0, 500, 0, 2000, distfrompreferredheight);
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = heightscore * -1;
			#/
			point.score = point.score + (heightscore * -1);
		}
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::positionquery_debugscores(queryresult);
	/#
		if(isdefined(getdvarint("")) && getdvarint(""))
		{
			recordline(self.origin, best_point.origin, (0.3, 1, 0));
			recordline(self.origin, self.parasiteenemy.origin, (1, 0, 0.4));
		}
	#/
	returndata = [];
	returndata["origin"] = (isdefined(best_point) ? best_point.origin : undefined);
	returndata["centerOnNav"] = queryresult.centeronnav;
	return returndata;
}

/*
	Name: path_update_interrupt
	Namespace: parasite
	Checksum: 0xFA8D0FA8
	Offset: 0x2650
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function path_update_interrupt()
{
	self endon(#"death");
	self endon(#"change_state");
	self endon(#"near_goal");
	self endon(#"reached_end_node");
	wait(1);
	while(true)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(distance2dsquared(self.current_pathto_pos, self.goalpos) > (self.goalradius * self.goalradius))
			{
				wait(0.2);
				self._override_juke = 1;
				self notify(#"near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: drone_pain_for_time
	Namespace: parasite
	Checksum: 0xD13122F6
	Offset: 0x2710
	Size: 0x1E0
	Parameters: 3
	Flags: Linked
*/
function drone_pain_for_time(time, stablizeparam, restorelookpoint)
{
	self endon(#"death");
	self.painstarttime = gettime();
	if(!(isdefined(self.inpain) && self.inpain))
	{
		self.inpain = 1;
		self playsound("zmb_vocals_parasite_pain");
		while(gettime() < (self.painstarttime + (time * 1000)))
		{
			self setvehvelocity(self.velocity * stablizeparam);
			self setangularvelocity(self getangularvelocity() * stablizeparam);
			wait(0.1);
		}
		if(isdefined(restorelookpoint))
		{
			restorelookent = spawn("script_model", restorelookpoint);
			restorelookent setmodel("tag_origin");
			self clearlookatent();
			self setlookatent(restorelookent);
			self setturrettargetent(restorelookent);
			wait(1.5);
			self clearlookatent();
			self clearturrettarget();
			restorelookent delete();
		}
		self.inpain = 0;
	}
}

/*
	Name: drone_pain
	Namespace: parasite
	Checksum: 0x3B977153
	Offset: 0x28F8
	Size: 0x124
	Parameters: 6
	Flags: None
*/
function drone_pain(eattacker, damagetype, hitpoint, hitdirection, hitlocationinfo, partname)
{
	if(!(isdefined(self.inpain) && self.inpain))
	{
		yaw_vel = math::randomsign() * randomfloatrange(280, 320);
		ang_vel = self getangularvelocity();
		ang_vel = ang_vel + (randomfloatrange(-120, -100), yaw_vel, randomfloatrange(-200, 200));
		self setangularvelocity(ang_vel);
		self thread drone_pain_for_time(0.8, 0.7);
	}
}

