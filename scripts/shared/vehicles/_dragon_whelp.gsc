// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace dragon;

/*
	Name: __init__sytem__
	Namespace: dragon
	Checksum: 0x95A02DCE
	Offset: 0x330
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("dragon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: dragon
	Checksum: 0x19735DDB
	Offset: 0x370
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	vehicle::add_main_callback("dragon", &dragon_initialize);
}

/*
	Name: dragon_initialize
	Namespace: dragon
	Checksum: 0x6E1FC824
	Offset: 0x3A8
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function dragon_initialize()
{
	self useanimtree($generic);
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	if(isdefined(self.scriptbundlesettings))
	{
		self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	/#
		assert(isdefined(self.settings));
	#/
	self setneargoalnotifydist(self.radius * 1.5);
	self sethoverparams(self.radius, self.settings.defaultmovespeed * 2, self.radius);
	self setspeed(self.settings.defaultmovespeed);
	blackboard::createblackboardforentity(self);
	self blackboard::registervehicleblackboardattributes();
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.vehaircraftcollisionenabled = 0;
	self.goalradius = 9999999;
	self.goalheight = 512;
	self setgoal(self.origin, 0, self.goalradius, self.goalheight);
	self.delete_on_death = 1;
	self.overridevehicledamage = &dragon_callback_damage;
	self.allowfriendlyfiredamageoverride = &dragon_allowfriendlyfiredamage;
	self.ignoreme = 1;
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	defaultrole();
}

/*
	Name: defaultrole
	Namespace: dragon
	Checksum: 0xB07A22BD
	Offset: 0x5F0
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function defaultrole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	if(sessionmodeiszombiesgame())
	{
		self vehicle_ai::add_state("power_up", undefined, &state_power_up_update, undefined);
		self vehicle_ai::add_utility_connection("combat", "power_up", &should_go_for_power_up);
		self vehicle_ai::add_utility_connection("power_up", "combat");
	}
	/#
		setdvar("", 0);
	#/
	self thread dragon_target_selection();
	vehicle_ai::startinitialstate("combat");
	self.starttime = gettime();
}

/*
	Name: is_enemy_valid
	Namespace: dragon
	Checksum: 0x301A319A
	Offset: 0x770
	Size: 0x1BE
	Parameters: 1
	Flags: Linked, Private
*/
function private is_enemy_valid(target)
{
	if(!isdefined(target))
	{
		return false;
	}
	if(!isalive(target))
	{
		return false;
	}
	if(isdefined(self.intermission) && self.intermission)
	{
		return false;
	}
	if(isdefined(target.ignoreme) && target.ignoreme)
	{
		return false;
	}
	if(target isnotarget())
	{
		return false;
	}
	if(isdefined(target._dragon_ignoreme) && target._dragon_ignoreme)
	{
		return false;
	}
	if(distancesquared(self.owner.origin, target.origin) > (self.settings.guardradius * self.settings.guardradius))
	{
		return false;
	}
	if(self vehcansee(target))
	{
		return true;
	}
	if(isactor(target) && target cansee(self.owner))
	{
		return true;
	}
	if(isvehicle(target) && target vehcansee(self.owner))
	{
		return true;
	}
	return false;
}

/*
	Name: get_dragon_enemy
	Namespace: dragon
	Checksum: 0xC3DB2B33
	Offset: 0x938
	Size: 0x29C
	Parameters: 0
	Flags: Linked, Private
*/
function private get_dragon_enemy()
{
	dragon_enemies = getaiteamarray("axis");
	distsqr = 10000 * 10000;
	best_enemy = undefined;
	foreach(enemy in dragon_enemies)
	{
		newdistsqr = distance2dsquared(enemy.origin, self.owner.origin);
		if(is_enemy_valid(enemy))
		{
			if(enemy.archetype === "raz")
			{
				newdistsqr = max(distance2d(enemy.origin, self.owner.origin) - 700, 0);
				newdistsqr = newdistsqr * newdistsqr;
			}
			else
			{
				if(enemy.archetype === "sentinel_drone")
				{
					newdistsqr = max(distance2d(enemy.origin, self.owner.origin) - 500, 0);
					newdistsqr = newdistsqr * newdistsqr;
				}
				else if(enemy === self.dragonenemy)
				{
					newdistsqr = max(distance2d(enemy.origin, self.owner.origin) - 300, 0);
					newdistsqr = newdistsqr * newdistsqr;
				}
			}
			if(newdistsqr < distsqr)
			{
				distsqr = newdistsqr;
				best_enemy = enemy;
			}
		}
	}
	return best_enemy;
}

/*
	Name: dragon_target_selection
	Namespace: dragon
	Checksum: 0x9CE7BF64
	Offset: 0xBE0
	Size: 0x100
	Parameters: 0
	Flags: Linked, Private
*/
function private dragon_target_selection()
{
	self endon(#"death");
	for(;;)
	{
		if(!isdefined(self.owner))
		{
			wait(0.25);
			continue;
		}
		if(isdefined(self.ignoreall) && self.ignoreall)
		{
			wait(0.25);
			continue;
		}
		/#
			if(getdvarint("", 0))
			{
				if(isdefined(self.dragonenemy))
				{
					line(self.origin, self.dragonenemy.origin, (1, 0, 0), 1, 0, 5);
				}
			}
		#/
		target = get_dragon_enemy();
		if(!isdefined(target))
		{
			self.dragonenemy = undefined;
		}
		else
		{
			self.dragonenemy = target;
		}
		wait(0.25);
	}
}

/*
	Name: state_power_up_update
	Namespace: dragon
	Checksum: 0x6AC2C56B
	Offset: 0xCE8
	Size: 0x264
	Parameters: 1
	Flags: Linked
*/
function state_power_up_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	closest_distsqr = 10000 * 10000;
	closest = undefined;
	foreach(powerup in level.active_powerups)
	{
		powerup.navvolumeorigin = self getclosestpointonnavvolume(powerup.origin, 100);
		if(!isdefined(powerup.navvolumeorigin))
		{
			continue;
		}
		distsqr = distancesquared(powerup.origin, self.origin);
		if(distsqr < closest_distsqr)
		{
			closest_distsqr = distsqr;
			closest = powerup;
		}
	}
	if(isdefined(closest) && distsqr < (2000 * 2000))
	{
		self setvehgoalpos(closest.navvolumeorigin, 1, 1);
		if(vehicle_ai::waittill_pathresult())
		{
			self vehicle_ai::waittill_pathing_done();
		}
		if(isdefined(closest))
		{
			trace = bullettrace(self.origin, closest.origin, 0, self);
			if(trace["fraction"] == 1)
			{
				self setvehgoalpos(closest.origin, 1, 0);
			}
		}
	}
	self vehicle_ai::evaluate_connections();
}

/*
	Name: should_go_for_power_up
	Namespace: dragon
	Checksum: 0x5C589533
	Offset: 0xF58
	Size: 0x5A
	Parameters: 3
	Flags: Linked
*/
function should_go_for_power_up(from_state, to_state, connection)
{
	if(level.whelp_no_power_up_pickup === 1)
	{
		return false;
	}
	if(isdefined(self.dragonenemy))
	{
		return false;
	}
	if(level.active_powerups.size < 1)
	{
		return false;
	}
	return true;
}

/*
	Name: state_combat_update
	Namespace: dragon
	Checksum: 0x170A7E76
	Offset: 0xFC0
	Size: 0x850
	Parameters: 1
	Flags: Linked
*/
function state_combat_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	idealdisttoowner = 300;
	self asmrequestsubstate("locomotion@movement");
	while(!isdefined(self.owner))
	{
		wait(0.05);
	}
	self thread attack_thread();
	for(;;)
	{
		self setspeed(self.settings.defaultmovespeed);
		self asmrequestsubstate("locomotion@movement");
		if(isdefined(self.owner) && distance2dsquared(self.origin, self.owner.origin) < (idealdisttoowner * idealdisttoowner) && ispointinnavvolume(self.origin, "navvolume_small"))
		{
			if(!isdefined(self.current_pathto_pos))
			{
				self.current_pathto_pos = self getclosestpointonnavvolume(self.origin, 100);
			}
			self setvehgoalpos(self.current_pathto_pos, 1, 0);
			wait(0.1);
			continue;
		}
		if(isdefined(self.owner))
		{
			queryresult = positionquery_source_navigation(self.origin, 0, 256, 90, self.radius, self);
			sighttarget = undefined;
			if(isdefined(self.dragonenemy))
			{
				sighttarget = self.dragonenemy geteye();
				positionquery_filter_sight(queryresult, sighttarget, (0, 0, 0), self, 4);
			}
			if(isdefined(queryresult.centeronnav) && queryresult.centeronnav)
			{
				ownerorigin = self.owner.origin;
				ownerforward = anglestoforward(self.owner.angles);
				best_point = undefined;
				best_score = -999999;
				foreach(point in queryresult.data)
				{
					distsqr = distance2dsquared(point.origin, ownerorigin);
					if(distsqr > (idealdisttoowner * idealdisttoowner))
					{
						/#
							if(!isdefined(point._scoredebug))
							{
								point._scoredebug = [];
							}
							point._scoredebug[""] = (sqrt(distsqr) * -1) * 2;
						#/
						point.score = point.score + ((sqrt(distsqr) * -1) * 2);
					}
					if(isdefined(point.visibility) && point.visibility)
					{
						if(bullettracepassed(point.origin, sighttarget, 0, self))
						{
							/#
								if(!isdefined(point._scoredebug))
								{
									point._scoredebug = [];
								}
								point._scoredebug[""] = 400;
							#/
							point.score = point.score + 400;
						}
					}
					vectoowner = point.origin - ownerorigin;
					dirtoowner = vectornormalize((vectoowner[0], vectoowner[1], 0));
					if(vectordot(ownerforward, dirtoowner) > 0.34)
					{
						if(abs(vectoowner[2]) < 100)
						{
							/#
								if(!isdefined(point._scoredebug))
								{
									point._scoredebug = [];
								}
								point._scoredebug[""] = 300;
							#/
							point.score = point.score + 300;
						}
						else if(abs(vectoowner[2]) < 200)
						{
							/#
								if(!isdefined(point._scoredebug))
								{
									point._scoredebug = [];
								}
								point._scoredebug[""] = 100;
							#/
							point.score = point.score + 100;
						}
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
					/#
						if(isdefined(getdvarint("")) && getdvarint(""))
						{
							recordline(self.origin, best_point.origin, (0.3, 1, 0));
							recordline(self.origin, self.owner.origin, (1, 0, 0.4));
						}
					#/
					if(distancesquared(self.origin, best_point.origin) > (50 * 50))
					{
						self.current_pathto_pos = best_point.origin;
						self setvehgoalpos(self.current_pathto_pos, 1, 1);
						self vehicle_ai::waittill_pathing_done(5);
					}
					else
					{
						self vehicle_ai::cooldown("move_cooldown", 4);
					}
				}
			}
			else
			{
				go_back_on_navvolume();
			}
		}
		wait(0.1);
	}
}

/*
	Name: attack_thread
	Namespace: dragon
	Checksum: 0x36FDCF4
	Offset: 0x1818
	Size: 0x250
	Parameters: 0
	Flags: Linked
*/
function attack_thread()
{
	self endon(#"change_state");
	self endon(#"death");
	for(;;)
	{
		wait(0.1);
		self vehicle_ai::evaluate_connections();
		if(!self vehicle_ai::iscooldownready("attack"))
		{
			continue;
		}
		if(!isdefined(self.dragonenemy))
		{
			continue;
		}
		self setlookatent(self.dragonenemy);
		if(!self vehcansee(self.dragonenemy))
		{
			continue;
		}
		if(distance2dsquared(self.dragonenemy.origin, self.owner.origin) > (self.settings.guardradius * self.settings.guardradius))
		{
			continue;
		}
		eyeoffset = (self.dragonenemy geteye() - self.dragonenemy.origin) * 0.6;
		if(!bullettracepassed(self.origin, self.dragonenemy geteye() - eyeoffset, 0, self, self.dragonenemy))
		{
			self.dragonenemy = undefined;
			continue;
		}
		aimoffset = (self.dragonenemy getvelocity() * 0.3) - eyeoffset;
		self setturrettargetent(self.dragonenemy, aimoffset);
		wait(0.2);
		if(isdefined(self.dragonenemy))
		{
			self fireweapon(0, self.dragonenemy, (0, 0, 0), self);
			self vehicle_ai::cooldown("attack", 1);
		}
	}
}

/*
	Name: go_back_on_navvolume
	Namespace: dragon
	Checksum: 0x43D208C4
	Offset: 0x1A70
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function go_back_on_navvolume()
{
	queryresult = positionquery_source_navigation(self.origin, 0, 100, 90, self.radius, self);
	multiplier = 2;
	while(queryresult.data.size < 1)
	{
		queryresult = positionquery_source_navigation(self.origin, 0, 100 * multiplier, 90 * multiplier, self.radius * multiplier, self);
		multiplier = multiplier + 2;
	}
	if(queryresult.data.size && !queryresult.centeronnav)
	{
		best_point = undefined;
		best_score = 999999;
		foreach(point in queryresult.data)
		{
			point.score = abs(point.origin[2] - queryresult.origin[2]);
			if(point.score < best_score)
			{
				best_score = point.score;
				best_point = point;
			}
		}
		if(isdefined(best_point))
		{
			self setneargoalnotifydist(2);
			point = best_point;
			self.current_pathto_pos = point.origin;
			foundpath = self setvehgoalpos(self.current_pathto_pos, 1, 0);
			if(foundpath)
			{
				self vehicle_ai::waittill_pathing_done(5);
			}
			self setneargoalnotifydist(self.radius);
		}
	}
}

/*
	Name: dragon_allowfriendlyfiredamage
	Namespace: dragon
	Checksum: 0xF44B4151
	Offset: 0x1D28
	Size: 0x26
	Parameters: 4
	Flags: Linked
*/
function dragon_allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon)
{
	return false;
}

/*
	Name: dragon_callback_damage
	Namespace: dragon
	Checksum: 0x5610BCB2
	Offset: 0x1D58
	Size: 0x94
	Parameters: 15
	Flags: Linked
*/
function dragon_callback_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(self.dragon_recall_death !== 1)
	{
		return 0;
	}
	return idamage;
}

/*
	Name: state_death_update
	Namespace: dragon
	Checksum: 0xB059842E
	Offset: 0x1DF8
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function state_death_update(params)
{
	self endon(#"death");
	attacker = params.inflictor;
	if(!isdefined(attacker))
	{
		attacker = params.attacker;
	}
	if(attacker !== self && (!isdefined(self.owner) || self.owner !== attacker) && (isai(attacker) || isplayer(attacker)))
	{
		self.damage_on_death = 0;
		wait(0.05);
		attacker = params.inflictor;
		if(!isdefined(attacker))
		{
			attacker = params.attacker;
		}
	}
	self vehicle_ai::defaultstate_death_update();
}

