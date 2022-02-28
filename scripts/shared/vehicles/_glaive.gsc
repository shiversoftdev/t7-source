// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\margwa;
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

#namespace glaive;

/*
	Name: __init__sytem__
	Namespace: glaive
	Checksum: 0xA11527FC
	Offset: 0x490
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("glaive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: glaive
	Checksum: 0xB691AEEA
	Offset: 0x4D0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	vehicle::add_main_callback("glaive", &glaive_initialize);
	clientfield::register("vehicle", "glaive_blood_fx", 1, 1, "int");
}

/*
	Name: glaive_initialize
	Namespace: glaive
	Checksum: 0xD0DB9DAC
	Offset: 0x538
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function glaive_initialize()
{
	self useanimtree($generic);
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self setneargoalnotifydist(50);
	self sethoverparams(0, 0, 40);
	self playloopsound("wpn_sword2_looper");
	if(isdefined(self.scriptbundlesettings))
	{
		self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	blackboard::createblackboardforentity(self);
	self blackboard::registervehicleblackboardattributes();
	self.fovcosine = 0;
	self.fovcosinebusy = 0.574;
	self.vehaircraftcollisionenabled = 0;
	self.goalradius = 9999999;
	self.goalheight = 512;
	self setgoal(self.origin, 0, self.goalradius, self.goalheight);
	self.overridevehicledamage = &glaive_callback_damage;
	self.allowfriendlyfiredamageoverride = &glaive_allowfriendlyfiredamage;
	self.ignoreme = 1;
	self._glaive_settings_lifetime = self.settings.lifetime;
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	defaultrole();
}

/*
	Name: defaultrole
	Namespace: glaive
	Checksum: 0x858D585F
	Offset: 0x740
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function defaultrole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("combat").enter_func = &state_combat_enter;
	self vehicle_ai::add_state("slash", undefined, &state_slash_update, undefined);
	/#
		setdvar("", 1);
	#/
	self thread glaive_target_selection();
	vehicle_ai::startinitialstate("combat");
	self.starttime = gettime();
}

/*
	Name: is_enemy_valid
	Namespace: glaive
	Checksum: 0xA618D061
	Offset: 0x850
	Size: 0x206
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
	if(isdefined(target._glaive_ignoreme) && target._glaive_ignoreme)
	{
		return false;
	}
	if(isdefined(target.archetype) && target.archetype == "margwa")
	{
		if(!target margwaserverutils::margwacandamageanyhead())
		{
			return false;
		}
	}
	if(isdefined(target.archetype) && target.archetype == "zombie" && (!(isdefined(target.completed_emerging_into_playable_area) && target.completed_emerging_into_playable_area)))
	{
		return false;
	}
	if(distancesquared(self.owner.origin, target.origin) > (self.settings.guardradius * self.settings.guardradius))
	{
		return false;
	}
	if(!sighttracepassed(self.origin, target.origin + vectorscale((0, 0, 1), 16), 0, target))
	{
		return false;
	}
	return true;
}

/*
	Name: get_glaive_enemy
	Namespace: glaive
	Checksum: 0xF317B23F
	Offset: 0xA60
	Size: 0xDA
	Parameters: 0
	Flags: Linked, Private
*/
function private get_glaive_enemy()
{
	glaive_enemies = getaiteamarray("axis");
	arraysortclosest(glaive_enemies, self.owner.origin);
	foreach(glaive_enemy in glaive_enemies)
	{
		if(is_enemy_valid(glaive_enemy))
		{
			return glaive_enemy;
		}
	}
}

/*
	Name: glaive_target_selection
	Namespace: glaive
	Checksum: 0xE2AE9D0D
	Offset: 0xB48
	Size: 0x158
	Parameters: 0
	Flags: Linked, Private
*/
function private glaive_target_selection()
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
				if(isdefined(self.glaiveenemy))
				{
					line(self.origin, self.glaiveenemy.origin, (1, 0, 0), 1, 0, 5);
				}
			}
		#/
		if(self is_enemy_valid(self.glaiveenemy))
		{
			wait(0.25);
			continue;
		}
		if(isdefined(self._glaive_must_return_to_owner) && self._glaive_must_return_to_owner)
		{
			wait(0.25);
			continue;
		}
		target = get_glaive_enemy();
		if(!isdefined(target))
		{
			self.glaiveenemy = undefined;
		}
		else
		{
			self.glaiveenemy = target;
		}
		wait(0.25);
	}
}

/*
	Name: should_go_to_owner
	Namespace: glaive
	Checksum: 0xF33A2D4
	Offset: 0xCA8
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function should_go_to_owner()
{
	b_is_lifetime_over = (gettime() - self.starttime) > (self._glaive_settings_lifetime * 1000);
	if(isdefined(b_is_lifetime_over) && b_is_lifetime_over)
	{
		return true;
	}
	if(self.owner.sword_power <= 0)
	{
		return true;
	}
	return false;
}

/*
	Name: should_go_to_near_owner
	Namespace: glaive
	Checksum: 0x7F033140
	Offset: 0xD18
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function should_go_to_near_owner()
{
	if(isdefined(self.owner) && distancesquared(self.origin, self.owner.origin) > (self.settings.guardradius * self.settings.guardradius))
	{
		return true;
	}
	if(isdefined(self.owner) && !self is_enemy_valid(self.glaiveenemy))
	{
		if(distance2dsquared(self.origin, self.owner.origin) > (160 * 160))
		{
			return true;
		}
		if(!util::within_fov(self.owner.origin, self.owner.angles, self.origin, cos(60)))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: state_combat_enter
	Namespace: glaive
	Checksum: 0xF8620B6E
	Offset: 0xE58
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function state_combat_enter(params)
{
	self asmrequestsubstate("idle@movement");
}

/*
	Name: state_combat_update
	Namespace: glaive
	Checksum: 0x4D8510A7
	Offset: 0xE90
	Size: 0x664
	Parameters: 1
	Flags: Linked
*/
function state_combat_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	pathfailcount = 0;
	while(!isdefined(self.owner))
	{
		wait(0.1);
		if(!isdefined(self.owner))
		{
			self.owner = getplayers(self.team)[0];
		}
	}
	for(;;)
	{
		if(self should_go_to_owner() || (isdefined(self._glaive_must_return_to_owner) && self._glaive_must_return_to_owner))
		{
			self._glaive_must_return_to_owner = 1;
			if(!isalive(self.glaiveenemy))
			{
				self go_to_owner();
			}
		}
		if(self should_go_to_near_owner())
		{
			self go_to_near_owner();
		}
		else if(isdefined(self.glaiveenemy))
		{
			foundpath = 0;
			targetpos = vehicle_ai::gettargetpos(self.glaiveenemy, 1);
			if(isdefined(self.glaiveenemy.archetype) && self.glaiveenemy.archetype == "margwa")
			{
				targetpos = self.glaiveenemy gettagorigin("j_chunk_head_bone");
			}
			targetpos = targetpos + (self.glaiveenemy getvelocity() * 0.4);
			if(isdefined(targetpos))
			{
				if(distance2dsquared(self.origin, self.glaiveenemy.origin) < (80 * 80))
				{
					self vehicle_ai::set_state("slash");
				}
				else if(isdefined(self.owner) && self is_enemy_valid(self.glaiveenemy) && self check_glaive_playable_area_conditions())
				{
					go_back_on_navvolume();
					queryresult = positionquery_source_navigation(targetpos, 0, 64, 64, 8, self);
					if(isdefined(self.glaiveenemy))
					{
						positionquery_filter_sight(queryresult, targetpos, self geteye() - self.origin, self, 0, self.glaiveenemy);
					}
					if(isdefined(queryresult.centeronnav) && queryresult.centeronnav)
					{
						foreach(point in queryresult.data)
						{
							if(isdefined(point.visibility) && point.visibility)
							{
								self.current_pathto_pos = point.origin;
								foundpath = self setvehgoalpos(self.current_pathto_pos, 1, 1);
								if(foundpath)
								{
									self asmrequestsubstate("forward@movement");
									self util::waittill_any("near_goal", "goal");
									self asmrequestsubstate("idle@movement");
									break;
								}
							}
						}
					}
					else
					{
						foreach(point in queryresult.data)
						{
							if(isdefined(point.visibility) && point.visibility)
							{
								self.current_pathto_pos = point.origin;
								foundpath = self setvehgoalpos(self.current_pathto_pos, 1, 0);
								if(foundpath)
								{
									self asmrequestsubstate("forward@movement");
									self util::waittill_any("near_goal", "goal");
									self asmrequestsubstate("idle@movement");
									break;
								}
							}
						}
					}
				}
			}
			if(!foundpath && self is_enemy_valid(self.glaiveenemy))
			{
				go_back_on_navvolume();
				pathfailcount++;
				if(pathfailcount > 3)
				{
					if(isdefined(self.owner))
					{
						self go_to_near_owner();
					}
				}
				wait(0.1);
			}
			else
			{
				pathfailcount = 0;
			}
		}
		wait(0.2);
	}
}

/*
	Name: check_glaive_playable_area_conditions
	Namespace: glaive
	Checksum: 0x928FA15F
	Offset: 0x1500
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function check_glaive_playable_area_conditions()
{
	if(isdefined(self.glaiveenemy.archetype) && self.glaiveenemy.archetype != "zombie")
	{
		return true;
	}
	if(isdefined(self.glaiveenemy.archetype) && self.glaiveenemy.archetype == "zombie" && (isdefined(self.glaiveenemy.completed_emerging_into_playable_area) && self.glaiveenemy.completed_emerging_into_playable_area))
	{
		return true;
	}
	return false;
}

/*
	Name: go_back_on_navvolume
	Namespace: glaive
	Checksum: 0xA42902E4
	Offset: 0x15A8
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function go_back_on_navvolume()
{
	queryresult = positionquery_source_navigation(self.origin, 0, 100, 64, 8, self);
	multiplier = 2;
	while(queryresult.data.size < 1)
	{
		queryresult = positionquery_source_navigation(self.origin, 0, 100 * multiplier, 64 * multiplier, 20 * multiplier, self);
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
				self util::waittill_any("goal", "near_goal");
			}
			self setneargoalnotifydist(50);
		}
	}
}

/*
	Name: chooseswordanim
	Namespace: glaive
	Checksum: 0xEF9A546C
	Offset: 0x1858
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function chooseswordanim(enemy)
{
	self endon(#"change_state");
	self endon(#"death");
	sword_anim = "o_zombie_zod_sword_projectile_melee_synced_a";
	self._glaive_linktotag = "tag_origin";
	if(isdefined(enemy.archetype))
	{
		switch(enemy.archetype)
		{
			case "parasite":
			{
				sword_anim = "o_zombie_zod_sword_projectile_melee_parasite_synced_a";
				break;
			}
			case "raps":
			{
				sword_anim = "o_zombie_zod_sword_projectile_melee_elemental_synced_a";
				break;
			}
			case "margwa":
			{
				sword_anim = "o_zombie_zod_sword_projectile_melee_margwa_m_synced_a";
				self._glaive_linktotag = "tag_sync";
				break;
			}
		}
	}
	return sword_anim;
}

/*
	Name: state_slash_update
	Namespace: glaive
	Checksum: 0x2BFD094C
	Offset: 0x1938
	Size: 0x46C
	Parameters: 1
	Flags: Linked
*/
function state_slash_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	enemy = self.glaiveenemy;
	should_reevaluate_target = 0;
	sword_anim = self chooseswordanim(enemy);
	self animscripted("anim_notify", enemy gettagorigin(self._glaive_linktotag), enemy gettagangles(self._glaive_linktotag), sword_anim, "normal", undefined, undefined, 0.3, 0.3);
	self clientfield::set("glaive_blood_fx", 1);
	self waittill(#"anim_notify");
	if(isalive(enemy) && isdefined(enemy.archetype) && enemy.archetype == "margwa")
	{
		if(isdefined(enemy.chop_actor_cb))
		{
			should_reevaluate_target = 1;
			enemy._glaive_ignoreme = 1;
			enemy thread glaive_ignore_cooldown(5);
			self.owner [[enemy.chop_actor_cb]](enemy, self, self.weapon);
		}
	}
	else
	{
		target_enemies = getaiteamarray("axis");
		foreach(target in target_enemies)
		{
			if(distance2dsquared(self.origin, target.origin) < (128 * 128))
			{
				if(isdefined(target.archetype) && target.archetype == "margwa")
				{
					continue;
				}
				target dodamage(target.health + 100, self.origin, self.owner, self, "none", "MOD_UNKNOWN", 0, self.weapon);
				self playsound("wpn_sword2_imp");
				if(isactor(target))
				{
					target zombie_utility::gib_random_parts();
					target startragdoll();
					target launchragdoll(100 * (vectornormalize(target.origin - self.origin)));
				}
			}
		}
	}
	self waittill(#"anim_notify", notetrack);
	while(!isdefined(notetrack) || notetrack != "end")
	{
		self waittill(#"anim_notify", notetrack);
	}
	self clientfield::set("glaive_blood_fx", 0);
	if(should_reevaluate_target)
	{
		target = get_glaive_enemy();
		self.glaiveenemy = target;
	}
	self vehicle_ai::set_state("combat");
}

/*
	Name: glaive_ignore_cooldown
	Namespace: glaive
	Checksum: 0x3A1F0CB2
	Offset: 0x1DB0
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function glaive_ignore_cooldown(duration)
{
	self endon(#"death");
	wait(duration);
	self._glaive_ignoreme = undefined;
}

/*
	Name: go_to_near_owner
	Namespace: glaive
	Checksum: 0x8F9968F4
	Offset: 0x1DE0
	Size: 0x3FC
	Parameters: 0
	Flags: Linked
*/
function go_to_near_owner()
{
	self endon(#"near_owner");
	self thread back_to_near_owner_check();
	starttime = gettime();
	self asmrequestsubstate("forward@movement");
	while((gettime() - starttime) < ((self._glaive_settings_lifetime * 1000) * 0.1))
	{
		go_back_on_navvolume();
		ownertargetpos = vehicle_ai::gettargetpos(self.owner, 1) - vectorscale((0, 0, 1), 4);
		ownerforwardvec = anglestoforward(self.owner.angles);
		targetpos = ownertargetpos + (80 * ownerforwardvec);
		searchcenter = self getclosestpointonnavvolume(ownertargetpos);
		if(isdefined(searchcenter))
		{
			queryresult = positionquery_source_navigation(searchcenter, 0, 144, 32, 12, self);
			foundpath = 0;
			foreach(point in queryresult.data)
			{
				/#
					if(!isdefined(point._scoredebug))
					{
						point._scoredebug = [];
					}
					point._scoredebug[""] = distancesquared(point.origin, targetpos) * -1;
				#/
				point.score = point.score + (distancesquared(point.origin, targetpos) * -1);
			}
			vehicle_ai::positionquery_postprocess_sortscore(queryresult);
			self vehicle_ai::positionquery_debugscores(queryresult);
			foreach(point in queryresult.data)
			{
				self.current_pathto_pos = point.origin;
				foundpath = self setvehgoalpos(self.current_pathto_pos, 1, 1);
				if(foundpath)
				{
					break;
				}
			}
			if(!foundpath)
			{
				self.current_pathto_pos = searchcenter;
				self setvehgoalpos(self.current_pathto_pos, 1, 1);
			}
		}
		wait(1);
	}
	self asmrequestsubstate("idle@movement");
}

/*
	Name: go_to_owner
	Namespace: glaive
	Checksum: 0x6B31F08F
	Offset: 0x21E8
	Size: 0x364
	Parameters: 0
	Flags: Linked
*/
function go_to_owner()
{
	self thread back_to_owner_check();
	starttime = gettime();
	self asmrequestsubstate("forward@movement");
	while((gettime() - starttime) < ((self._glaive_settings_lifetime * 1000) * 0.3))
	{
		go_back_on_navvolume();
		targetpos = vehicle_ai::gettargetpos(self.owner, 1);
		queryresult = positionquery_source_navigation(targetpos, 0, 64, 64, 8, self);
		foundpath = 0;
		trace_count = 0;
		foreach(point in queryresult.data)
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
			self.current_pathto_pos = point.origin;
			foundpath = self setvehgoalpos(self.current_pathto_pos, 1, 1);
			if(foundpath)
			{
				break;
			}
		}
		if(!foundpath)
		{
			foreach(point in queryresult.data)
			{
				self.current_pathto_pos = point.origin;
				foundpath = self setvehgoalpos(self.current_pathto_pos, 1, 0);
				if(foundpath)
				{
					break;
				}
			}
		}
		wait(1);
	}
	if(isdefined(self.owner))
	{
		self.origin = self.owner.origin + vectorscale((0, 0, 1), 40);
	}
	self notify(#"returned_to_owner");
	wait(2);
}

/*
	Name: back_to_owner_check
	Namespace: glaive
	Checksum: 0x373944F1
	Offset: 0x2558
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function back_to_owner_check()
{
	self endon(#"death");
	while(isdefined(self.owner) && ((abs(self.origin[2] - self.owner.origin[2])) > (80 * 80) || distance2dsquared(self.origin, self.owner.origin) > (80 * 80)))
	{
		wait(0.1);
	}
	self notify(#"returned_to_owner");
}

/*
	Name: back_to_near_owner_check
	Namespace: glaive
	Checksum: 0xE937D992
	Offset: 0x2618
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function back_to_near_owner_check()
{
	self endon(#"death");
	while(isdefined(self.owner) && ((abs(self.origin[2] - self.owner.origin[2])) > (160 * 160) || distance2dsquared(self.origin, self.owner.origin) > (160 * 160) || !util::within_fov(self.owner.origin, self.owner.angles, self.origin, cos(60))))
	{
		wait(0.1);
	}
	self asmrequestsubstate("idle@movement");
	self notify(#"near_owner");
}

/*
	Name: glaive_allowfriendlyfiredamage
	Namespace: glaive
	Checksum: 0x72C20D9D
	Offset: 0x2750
	Size: 0x26
	Parameters: 4
	Flags: Linked
*/
function glaive_allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon)
{
	return false;
}

/*
	Name: glaive_callback_damage
	Namespace: glaive
	Checksum: 0x28D9CD22
	Offset: 0x2780
	Size: 0x80
	Parameters: 15
	Flags: Linked
*/
function glaive_callback_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	return true;
}

