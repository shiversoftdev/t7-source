// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_achievements;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\animation_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace cybercom_gadget_firefly;

/*
	Name: init
	Namespace: cybercom_gadget_firefly
	Checksum: 0xD697869
	Offset: 0x8B0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("vehicle", "firefly_state", 1, 4, "int");
	clientfield::register("actor", "firefly_state", 1, 4, "int");
	scene::add_scene_func("p7_fxanim_gp_ability_firefly_launch_bundle", &on_scene_firefly_launch, "play");
	scene::add_scene_func("p7_fxanim_gp_ability_firebug_launch_bundle", &on_scene_firefly_launch, "play");
}

/*
	Name: main
	Namespace: cybercom_gadget_firefly
	Checksum: 0xF97F2A90
	Offset: 0x980
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(2, 8, 1);
	level.cybercom.firefly_swarm = spawnstruct();
	level.cybercom.firefly_swarm._is_flickering = &_is_flickering;
	level.cybercom.firefly_swarm._on_flicker = &_on_flicker;
	level.cybercom.firefly_swarm._on_give = &_on_give;
	level.cybercom.firefly_swarm._on_take = &_on_take;
	level.cybercom.firefly_swarm._on_connect = &_on_connect;
	level.cybercom.firefly_swarm._on = &_on;
	level.cybercom.firefly_swarm._off = &_off;
	level.cybercom.firefly_swarm._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_firefly
	Checksum: 0xADC32B30
	Offset: 0xB10
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_firefly
	Checksum: 0x5F7CE284
	Offset: 0xB28
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_firefly
	Checksum: 0xD8EA36DE
	Offset: 0xB48
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self thread cybercom::function_b5f4e597(weapon);
	self cybercom::function_8257bcb3("base_rifle", 2);
	self cybercom::function_8257bcb3("fem_rifle", 2);
	self cybercom::function_8257bcb3("riotshield", 2);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_firefly
	Checksum: 0xAFACF266
	Offset: 0xC20
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
}

/*
	Name: _on_connect
	Namespace: cybercom_gadget_firefly
	Checksum: 0x99EC1590
	Offset: 0xC40
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_firefly
	Checksum: 0x2F1D4256
	Offset: 0xC50
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	cybercom::function_adc40f11(weapon, 1);
	self thread spawn_firefly_swarm(self hascybercomability("cybercom_fireflyswarm") == 2);
	self notify(#"bhtn_action_notify", "firefly_deploy");
	if(isplayer(self))
	{
		itemindex = getitemindexfromref("cybercom_fireflyswarm");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: _off
	Namespace: cybercom_gadget_firefly
	Checksum: 0xC9F26572
	Offset: 0xD50
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
}

/*
	Name: _is_primed
	Namespace: cybercom_gadget_firefly
	Checksum: 0x36B4B19
	Offset: 0xD70
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _is_primed(slot, weapon)
{
}

/*
	Name: ai_activatefireflyswarm
	Namespace: cybercom_gadget_firefly
	Checksum: 0x6E6BEBCE
	Offset: 0xD90
	Size: 0x2DC
	Parameters: 3
	Flags: Linked
*/
function ai_activatefireflyswarm(target, var_9bc2efcb = 1, upgraded = 1)
{
	self endon(#"death");
	if(self.archetype != "human")
	{
		return;
	}
	if(isdefined(var_9bc2efcb) && var_9bc2efcb)
	{
		type = self cybercom::function_5e3d3aa();
		self orientmode("face default");
		self animscripted("ai_cybercom_anim", self.origin, self.angles, ("ai_base_rifle_" + type) + "_exposed_cybercom_activate");
		self playsound("gdt_firefly_activate_npc");
		self waittillmatch(#"ai_cybercom_anim");
	}
	if(isarray(target))
	{
		foreach(guy in target)
		{
			if(!isdefined(guy))
			{
				continue;
			}
			if(isdefined(guy.archetype) && (guy.archetype == "human" || guy.archetype == "human_riotshield" || guy.archetype == "zombie"))
			{
				self thread spawn_firefly_swarm(upgraded, guy, 1);
			}
		}
	}
	else if(isdefined(target))
	{
		if(isdefined(target.archetype) && (target.archetype == "human" || target.archetype == "human_riotshield" || target.archetype == "zombie"))
		{
			self thread spawn_firefly_swarm(upgraded, target);
		}
	}
}

/*
	Name: on_scene_firefly_launch
	Namespace: cybercom_gadget_firefly
	Checksum: 0xF5D479F6
	Offset: 0x1078
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function on_scene_firefly_launch(a_ents)
{
	anim_model = a_ents["ability_firefly_launch"];
	anim_model waittill(#"firefly_launch_vehicle");
	if(isdefined(anim_model))
	{
		origin = anim_model gettagorigin("tag_fx_01_end_jnt");
		angles = anim_model gettagangles("tag_fx_01_end_jnt");
		anim_model delete();
	}
	if(isdefined(self.owner))
	{
		if(!isdefined(origin))
		{
			origin = self.owner.origin + vectorscale((0, 0, 1), 72);
		}
		if(!isdefined(angles))
		{
			angles = self.owner.angles;
		}
		self.owner notify(#"firefly_intro_done", origin, angles);
	}
}

/*
	Name: initthreatbias
	Namespace: cybercom_gadget_firefly
	Checksum: 0x71A2327F
	Offset: 0x11A0
	Size: 0xD2
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
		if(ai.ignorefirefly === 1)
		{
			ai setpersonalignore(self);
		}
	}
}

/*
	Name: spawn_firefly_swarm
	Namespace: cybercom_gadget_firefly
	Checksum: 0xFA7BC0BE
	Offset: 0x1280
	Size: 0x968
	Parameters: 4
	Flags: Linked
*/
function spawn_firefly_swarm(upgraded, targetent, swarms = getdvarint("scr_firefly_swarm_count", 3), swarmsplits = getdvarint("scr_firefly_swarm_split_count", 0))
{
	self endon(#"death");
	lifetime = getdvarint("scr_firefly_swarm_lifetime", 14);
	splitsleft = swarmsplits;
	offspring = 0;
	firebugs = 0;
	fovtargets = [];
	if(isdefined(targetent) && (isdefined(targetent.is_disabled) && targetent.is_disabled))
	{
		targetent = undefined;
	}
	if(!isvehicle(self))
	{
		s_anim_pos = spawnstruct();
		s_anim_pos.owner = self;
		if(isplayer(self))
		{
			origin = self geteye();
			angles = self getplayerangles();
		}
		else
		{
			origin = self gettagorigin("tag_eye");
			angles = self gettagangles("tag_eye");
		}
		frontgoal = origin + (anglestoforward(angles) * 100);
		trace = bullettrace(origin, frontgoal, 0, undefined);
		if(trace["fraction"] == 1)
		{
			s_anim_pos.origin = origin;
			s_anim_pos.angles = angles;
			if(upgraded)
			{
				if(sessionmodeiscampaignzombiesgame() && isworldpaused())
				{
				}
				else
				{
					s_anim_pos thread scene::play("p7_fxanim_gp_ability_firebug_launch_bundle");
					self waittill(#"firefly_intro_done", origin, angles);
				}
			}
			else
			{
				if(sessionmodeiscampaignzombiesgame() && isworldpaused())
				{
				}
				else
				{
					s_anim_pos thread scene::play("p7_fxanim_gp_ability_firefly_launch_bundle");
					self waittill(#"firefly_intro_done", origin, angles);
				}
			}
		}
		else
		{
			origin = self.origin + vectorscale((0, 0, 1), 72);
			angles = self.angles;
		}
		if(upgraded)
		{
			lifetime = getdvarint("scr_firefly_swarm_upgraded_lifetime", 14);
			firebugs = getdvarint("scr_firefly_swarm_firebug_count", 1);
		}
		lifetime = lifetime * 1000;
		shelflife = gettime() + lifetime;
		fovtargets = self get_swarm_targetswithinfov(self.origin, self.angles);
	}
	else
	{
		shelflife = self.lifetime;
		swarms = 1;
		splitsleft = 0;
		offspring = 1;
		firebugs = (isdefined(self.firebugcount) ? self.firebugcount : 0);
		origin = self.origin;
		angles = self.angles;
	}
	while(swarms)
	{
		swarm = spawnvehicle("spawner_bo3_cybercom_firefly", origin, angles, "firefly_swarm");
		swarms--;
		if(isdefined(swarm))
		{
			if(sessionmodeiscampaignzombiesgame())
			{
				swarm setignorepauseworld(1);
			}
			swarm.threatbias = -300;
			if(!isdefined(targetent))
			{
				if(fovtargets.size)
				{
					targetent = cybercom::getclosestto(swarm.origin, fovtargets);
					arrayremovevalue(fovtargets, targetent, 0);
				}
			}
			swarm.swarm_id = level.cybercom.swarms_released;
			swarm.owner = self;
			swarm.team = self.team;
			swarm.lifetime = shelflife;
			swarm.splitsleft = splitsleft;
			swarm.targetent = targetent;
			swarm.isoffspring = offspring;
			swarm.firebugcount = firebugs;
			swarm.firefly = 1;
			swarm.debug = spawnstruct();
			swarm.debug.main = 0;
			swarm.debug.attack = 0;
			swarm.debug.hunt = 0;
			swarm.debug.move = 0;
			swarm.debug.dead = 0;
			swarm initthreatbias();
			swarm.state_machine = statemachine::create("brain", swarm, "swarm_change_state");
			swarm.state_machine statemachine::add_state("init", &swarm_state_enter, &swarm_init, &swarm_state_cleanup);
			swarm.state_machine statemachine::add_state("main", &swarm_state_enter, &swarm_main_think, &swarm_state_cleanup);
			swarm.state_machine statemachine::add_state("move", &swarm_state_enter, &swarm_move_think, &swarm_state_cleanup);
			swarm.state_machine statemachine::add_state("attack", &swarm_state_enter, &swarm_attack_think, &swarm_state_cleanup);
			swarm.state_machine statemachine::add_state("hunt", &swarm_state_enter, &swarm_hunt_think, &swarm_state_cleanup);
			swarm.state_machine statemachine::add_state("dead", &swarm_state_enter, &swarm_dead_think, &swarm_state_cleanup);
			swarm.state_machine statemachine::set_state("init");
			targetent = undefined;
		}
		level notify(#"cybercom_swarm_released", swarm);
		level.cybercom.swarms_released = level.cybercom.swarms_released + 1;
		level.cybercom.var_12f85dec++;
	}
}

/*
	Name: function_54bc061f
	Namespace: cybercom_gadget_firefly
	Checksum: 0x154F396E
	Offset: 0x1BF0
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_54bc061f()
{
	self endon(#"death");
	wait(0.1);
	for(;;)
	{
		self setspeed(self.settings.defaultmovespeed);
		self.current_pathto_pos = getnextmoveposition_tactical();
		if(isdefined(self.current_pathto_pos))
		{
			usepathfinding = 1;
			if(self.isonnav === 0)
			{
				usepathfinding = 0;
			}
			if(self setvehgoalpos(self.current_pathto_pos, 1, usepathfinding))
			{
				self thread path_update_interrupt();
				self vehicle_ai::waittill_pathing_done();
			}
		}
		wait(0.5);
	}
}

/*
	Name: path_update_interrupt
	Namespace: cybercom_gadget_firefly
	Checksum: 0x70CC82BA
	Offset: 0x1CE0
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function path_update_interrupt()
{
	self endon(#"death");
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
				self notify(#"near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: getnextmoveposition_tactical
	Namespace: cybercom_gadget_firefly
	Checksum: 0x104AC3E7
	Offset: 0x1D88
	Size: 0x316
	Parameters: 0
	Flags: Linked
*/
function getnextmoveposition_tactical()
{
	if(self.goalforced)
	{
		goalpos = self getclosestpointonnavvolume(self.goalpos, 100);
		if(isdefined(goalpos))
		{
			if(distancesquared(goalpos, self.goalpos) > (50 * 50))
			{
				self.isonnav = 0;
			}
			return goalpos;
		}
		return self.goalpos;
	}
	querymultiplier = 1;
	queryresult = positionquery_source_navigation(self.origin, 80, 500 * querymultiplier, 500, (3 * self.radius) * querymultiplier, self, self.radius * querymultiplier);
	positionquery_filter_distancetogoal(queryresult, self);
	vehicle_ai::positionquery_filter_outofgoalanchor(queryresult);
	self.isonnav = queryresult.centeronnav;
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryresult.data)
	{
		randomscore = randomfloatrange(0, 100);
		disttooriginscore = point.disttoorigin2d * 0.2;
		point.score = point.score + (randomscore + disttooriginscore);
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = disttooriginscore;
		#/
		point.score = point.score + disttooriginscore;
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::positionquery_debugscores(queryresult);
	if(!isdefined(best_point))
	{
		return undefined;
	}
	return best_point.origin;
}

/*
	Name: swarm_state_cleanup
	Namespace: cybercom_gadget_firefly
	Checksum: 0xF691E8F5
	Offset: 0x20A8
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function swarm_state_cleanup(params)
{
	if(isdefined(self.badplace))
	{
		badplace_delete("swarmBP_" + self.swarm_id);
		self.badplace = undefined;
	}
}

/*
	Name: swarm_state_enter
	Namespace: cybercom_gadget_firefly
	Checksum: 0x7C4ABDD6
	Offset: 0x20F8
	Size: 0x14
	Parameters: 1
	Flags: Linked
*/
function swarm_state_enter(params)
{
	wait(0.05);
}

/*
	Name: getenemyteam
	Namespace: cybercom_gadget_firefly
	Checksum: 0xC9FC7B5D
	Offset: 0x2118
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function getenemyteam()
{
	if(self.team === "axis")
	{
		return "allies";
	}
	return "axis";
}

/*
	Name: swarm_init
	Namespace: cybercom_gadget_firefly
	Checksum: 0xE27D6667
	Offset: 0x2150
	Size: 0x634
	Parameters: 1
	Flags: Linked
*/
function swarm_init(params)
{
	self setmodel("tag_origin");
	self notsolid();
	self.notsolid = 1;
	self.vehaircraftcollisionenabled = 0;
	self notify(#"end_nudge_collision");
	self.ignoreall = 1;
	self.takedamage = 0;
	self.goalradius = 36;
	self.goalheight = 36;
	self.good_melee_target = 1;
	self setneargoalnotifydist(48);
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(getdvarint("scr_firefly_swarm_debug", 0))
	{
		self thread cybercom::draworiginforever();
	}
	self thread swarm_death_wait();
	self thread swarm_split_monitor();
	self clearforcedgoal();
	self setgoal(self.origin, 1, self.goalradius);
	if(!ispointinnavvolume(self.origin, "navvolume_small"))
	{
		if(isdefined(self.owner))
		{
			eye_origin = self.owner geteye();
		}
		else
		{
			eye_origin = self.origin;
		}
		pointonnavvolume = self getclosestpointonnavvolume(eye_origin, 100);
		if(isdefined(pointonnavvolume))
		{
			if(!self.firebugcount)
			{
				self clientfield::set("firefly_state", 2);
			}
			else
			{
				self clientfield::set("firefly_state", 7);
			}
			self setvehgoalpos(pointonnavvolume, 1, 0);
			self util::waittill_any_timeout(2, "near_goal");
		}
	}
	self thread function_54bc061f();
	if(!(isdefined(self.isoffspring) && self.isoffspring))
	{
		enemies = self _get_valid_targets();
		closetargets = arraysortclosest(enemies, self.origin, enemies.size, 0, 512);
		if(closetargets.size == 0)
		{
			angles = (self.angles[0], self.angles[1], 0);
			frontgoal = self.origin + (anglestoforward(angles) * 240);
			a_trace = bullettrace(self.origin, frontgoal, 0, undefined, 1);
			hitp = a_trace["position"];
			queryresult = positionquery_source_navigation(hitp, 0, 72, 72, 20, self);
			if(queryresult.data.size > 0)
			{
				pathsuccess = self findpath(self.origin, queryresult.data[0].origin, 1, 0);
				if(pathsuccess)
				{
					if(getdvarint("scr_firefly_swarm_debug", 0))
					{
						level thread cybercom::debug_circle(queryresult.data[0].origin, 16, 10, (1, 0, 0));
					}
					self clearforcedgoal();
					self setgoal(queryresult.data[0].origin, 1, self.goalradius);
					if(!self.firebugcount)
					{
						self clientfield::set("firefly_state", 2);
					}
					else
					{
						self clientfield::set("firefly_state", 7);
					}
					self util::waittill_any_timeout(5, "near_goal");
				}
			}
		}
	}
	if(isdefined(self.targetent) && isalive(self.targetent))
	{
		self.targetent.swarm = self;
		self.state_machine statemachine::set_state("move");
	}
	else
	{
		self.state_machine statemachine::set_state("hunt");
	}
}

/*
	Name: swarm_split_monitor
	Namespace: cybercom_gadget_firefly
	Checksum: 0x9631C0F9
	Offset: 0x2790
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function swarm_split_monitor()
{
	self endon(#"swarm_is_dead");
	self endon(#"death");
	wait(3);
	while(self.splitsleft > 0)
	{
		wait(0.5);
		nearent = self swarm_find_good_target(getdvarint("scr_firefly_swarm_split_radius", 864));
		if(isdefined(nearent))
		{
			self thread spawn_firefly_swarm(0, nearent);
			self.splitsleft--;
		}
	}
}

/*
	Name: swarm_attackhumantarget
	Namespace: cybercom_gadget_firefly
	Checksum: 0x27B62359
	Offset: 0x2838
	Size: 0x350
	Parameters: 1
	Flags: Linked
*/
function swarm_attackhumantarget(target)
{
	reactionanims = [];
	base = "base_rifle";
	if(isdefined(self.voiceprefix) && getsubstr(self.voiceprefix, 7) == "f")
	{
		base = "fem_rifle";
	}
	else if(target.archetype === "human_riotshield")
	{
		base = "riotshield";
	}
	type = target cybercom::function_5e3d3aa();
	if(type == "")
	{
		target.swarm = undefined;
		self.targetent = undefined;
		target.var_86386274 = gettime() + 1000;
		self.state_machine statemachine::set_state("main");
		return;
	}
	self thread swarm_monitortargetdeath(target);
	self clientfield::set("firefly_state", 1);
	variant = self.owner cybercom::getanimationvariant(base);
	if(self.firebugcount > 0)
	{
		self.firebugcount--;
		reactionanims["intro"] = (((("ai_" + base) + "_") + type) + "_exposed_swarm_upg_react_intro") + variant;
		target thread _firebombtarget(self, reactionanims, getweapon("gadget_firefly_swarm_upgraded"));
		target notify(#"bhtn_action_notify", "fireflyAttack");
		target clientfield::set("firefly_state", 9);
	}
	else
	{
		if(target.archetype === "human")
		{
			reactionanims["intro"] = (((("ai_" + base) + "_") + type) + "_exposed_swarm_react_intro") + variant;
			reactionanims["outro"] = (((("ai_" + base) + "_") + type) + "_exposed_swarm_react_outro") + variant;
		}
		else
		{
			reactionanims = [];
		}
		target clientfield::set("firefly_state", 4);
		target thread _reacttoswarm(self, reactionanims, getweapon("gadget_firefly_swarm"));
		target notify(#"bhtn_action_notify", "fireflyAttack");
	}
	self waittill(#"attack_stopped");
}

/*
	Name: swarm_attackzombietarget
	Namespace: cybercom_gadget_firefly
	Checksum: 0xCD248B28
	Offset: 0x2B90
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function swarm_attackzombietarget(target)
{
	/#
		assert(isdefined(target));
	#/
	if(!self.firebugcount)
	{
		target clientfield::set("firefly_state", 4);
	}
	else
	{
		target clientfield::set("firefly_state", 9);
	}
	if(self.firebugcount > 0)
	{
		self.firebugcount--;
		target clientfield::set("arch_actor_fire_fx", 1);
		target.health = 1;
	}
	wait(1);
	if(isdefined(target))
	{
		target.swarm = undefined;
	}
	wait(randomintrange(3, 7));
	if(isdefined(target) && isalive(target))
	{
		target dodamage(target.health, target.origin, undefined, undefined, "none", "MOD_BURNED");
	}
}

/*
	Name: function_cb5f9a2
	Namespace: cybercom_gadget_firefly
	Checksum: 0xCBD5A040
	Offset: 0x2D00
	Size: 0x1F0
	Parameters: 1
	Flags: Linked
*/
function function_cb5f9a2(target)
{
	/#
		assert(isdefined(target));
	#/
	if(!self.firebugcount)
	{
		target clientfield::set("firefly_state", 4);
	}
	else
	{
		target clientfield::set("firefly_state", 9);
	}
	self thread swarm_monitortargetdeath(target);
	self clientfield::set("firefly_state", 1);
	reactionanims = [];
	if(self.firebugcount > 0 && target.health <= getdvarint("scr_firefly_swarm_warlord_hitpoint_allowed_thresh", 400))
	{
		self.firebugcount--;
		target thread _firebombtarget(self, reactionanims, getweapon("gadget_firefly_swarm_upgraded"));
		target notify(#"bhtn_action_notify", "fireflyAttack");
		target clientfield::set("firefly_state", 9);
	}
	else
	{
		target clientfield::set("firefly_state", 4);
		target thread _reacttoswarm(self, reactionanims, getweapon("gadget_firefly_swarm"));
		target notify(#"bhtn_action_notify", "fireflyAttack");
	}
	self waittill(#"attack_stopped");
}

/*
	Name: swarm_attackplayertarget
	Namespace: cybercom_gadget_firefly
	Checksum: 0x6169CE67
	Offset: 0x2EF8
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function swarm_attackplayertarget(target)
{
	self thread fireflyplayereffect(target);
	if(isdefined(self.owner))
	{
		attacker = self.owner;
	}
	else
	{
		attacker = self;
	}
	target dodamage(getdvarint("scr_swarm_player_damage", 50), target.origin, attacker, self, "none", "MOD_UNKNOWN", 0, getweapon("gadget_firefly_swarm_upgraded"));
}

/*
	Name: swarm_attack_think
	Namespace: cybercom_gadget_firefly
	Checksum: 0xF45241EF
	Offset: 0x2FC0
	Size: 0x39C
	Parameters: 1
	Flags: Linked
*/
function swarm_attack_think(params)
{
	self endon(#"swarm_is_dead");
	self endon(#"death");
	self.debug.attack++;
	self clientfield::set("firefly_state", 1);
	target = self.targetent;
	if(!isdefined(target) || !isalive(target))
	{
		self.targetent = undefined;
		self.state_machine statemachine::set_state("main");
		return;
	}
	target notify(#"hash_f8c5dd60", getweapon("gadget_firefly_swarm"), self.owner);
	if(!self.firebugcount)
	{
		target clientfield::set("firefly_state", 4);
	}
	else
	{
		target clientfield::set("firefly_state", 9);
	}
	if(isdefined(target.archetype))
	{
		if(target.archetype == "human" || target.archetype == "human_riotshield")
		{
			self setgoal(self.targetent.origin + vectorscale((0, 0, 1), 48), 1, self.goalradius);
			badplace_cylinder("swarmBP_" + self.swarm_id, 0, target.origin, 256, 80, "axis");
			self.badplace = 1;
			self swarm_attackhumantarget(target);
		}
		else
		{
			if(target.archetype == "zombie")
			{
				self swarm_attackzombietarget(target);
			}
			else if(target.archetype == "warlord")
			{
				self function_cb5f9a2(target);
			}
		}
	}
	else if(isplayer(target))
	{
		self setgoal(self.targetent.origin + vectorscale((0, 0, 1), 48), 1, self.goalradius);
		badplace_cylinder("swarmBP_" + self.swarm_id, 0, target.origin, 256, 80, "axis");
		self.badplace = 1;
		self swarm_attackplayertarget(target);
	}
	self.targetent = undefined;
	self.state_machine statemachine::set_state("main");
	self.debug.attack--;
}

/*
	Name: swarm_monitortargetdeath
	Namespace: cybercom_gadget_firefly
	Checksum: 0xCCF3C95B
	Offset: 0x3368
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function swarm_monitortargetdeath(target)
{
	self endon(#"death");
	self endon(#"attack_stopped");
	target waittill(#"death");
	self notify(#"attack_stopped");
}

/*
	Name: _firebombtargetpain
	Namespace: cybercom_gadget_firefly
	Checksum: 0x96299D04
	Offset: 0x33B0
	Size: 0xBA
	Parameters: 3
	Flags: Linked, Private
*/
function private _firebombtargetpain(swarm, reactionanims, weapon)
{
	self endon(#"death");
	if(isdefined(swarm))
	{
		self dodamage(5, self.origin, swarm.owner, swarm, "none", "MOD_BURNED", 0, weapon, -1, 1);
	}
	if(!self cybercom::function_421746e0())
	{
		self waittillmatch(#"bhtn_action_terminate");
	}
	self notify(#"firebug_time_to_die", "specialpain");
}

/*
	Name: _firebombtargetcorpselistener
	Namespace: cybercom_gadget_firefly
	Checksum: 0x6A605B37
	Offset: 0x3478
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private _firebombtargetcorpselistener()
{
	self waittill(#"actor_corpse", corpse);
	corpse clientfield::set("arch_actor_fire_fx", 2);
}

/*
	Name: _firebombtarget
	Namespace: cybercom_gadget_firefly
	Checksum: 0xDEC40CA7
	Offset: 0x34C0
	Size: 0x344
	Parameters: 3
	Flags: Linked, Private
*/
function private _firebombtarget(swarm, reactionanims, weapon)
{
	self endon(#"death");
	self.ignoreall = 1;
	self.is_disabled = 1;
	var_c318824b = 0;
	self notify(#"hash_37486b44", swarm);
	level notify(#"hash_37486b44", self, swarm);
	if(self cybercom::islinked())
	{
		self unlink();
		var_c318824b = 1;
	}
	if(!(isdefined(var_c318824b) && var_c318824b) && isdefined(reactionanims["intro"]))
	{
		self animscripted("swarm_intro_anim", self.origin, self.angles, reactionanims["intro"]);
		self waittillmatch(#"swarm_intro_anim");
	}
	self clientfield::set("arch_actor_fire_fx", 1);
	self thread _firebombtargetcorpselistener();
	if(!(isdefined(var_c318824b) && var_c318824b))
	{
		self thread _firebombtargetpain(swarm, reactionanims, weapon);
		self util::waittill_any_timeout(getdvarint("scr_firefly_swarm_human_burn_duration", 10), "firebug_time_to_die");
	}
	self clientfield::set("firefly_state", 10);
	if(isdefined(swarm))
	{
		swarm notify(#"attack_stopped", "end");
		if(isdefined(self.voiceprefix) && isdefined(self.bcvoicenumber))
		{
			self thread battlechatter::do_sound((self.voiceprefix + self.bcvoicenumber) + "_exert_firefly_burning", 1);
		}
		swarm.owner notify(#"hash_304642e3");
		self dodamage(self.health, self.origin, swarm.owner, swarm, "none", "MOD_BURNED", 0, weapon, -1, 1);
	}
	else
	{
		if(isdefined(self.voiceprefix) && isdefined(self.bcvoicenumber))
		{
			self thread battlechatter::do_sound((self.voiceprefix + self.bcvoicenumber) + "_exert_firefly_burning", 1);
		}
		self dodamage(self.health, self.origin, undefined, undefined, "none", "MOD_BURNED", 0, weapon, -1, 1);
	}
}

/*
	Name: _deathlistener
	Namespace: cybercom_gadget_firefly
	Checksum: 0x188338F0
	Offset: 0x3810
	Size: 0x72
	Parameters: 1
	Flags: Private
*/
function private _deathlistener(swarm)
{
	while(isdefined(swarm))
	{
		self util::waittill_any_timeout(1, "damage");
		if(isdefined(self) && self.health <= 0)
		{
			self clientfield::set("firefly_state", 10);
			return;
		}
	}
}

/*
	Name: _corpsewatcher
	Namespace: cybercom_gadget_firefly
	Checksum: 0x88C1F5D2
	Offset: 0x3890
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private _corpsewatcher(swarm)
{
	swarm endon(#"death");
	self waittill(#"actor_corpse", corpse);
	corpse clientfield::set("firefly_state", 10);
}

/*
	Name: function_963f8ef6
	Namespace: cybercom_gadget_firefly
	Checksum: 0xA54D7D0A
	Offset: 0x38F0
	Size: 0xB4
	Parameters: 4
	Flags: None
*/
function function_963f8ef6(match, note, var_1ccbc268, end)
{
	self endon(#"death");
	if(isdefined(end))
	{
		self endon(end);
		while(true)
		{
			if(isdefined(match))
			{
				self waittillmatch(match);
			}
			else
			{
				self waittill(note);
			}
			self notify(var_1ccbc268, note);
		}
	}
	else
	{
		if(isdefined(match))
		{
			self waittillmatch(match);
		}
		else
		{
			self waittill(note);
		}
		self notify(var_1ccbc268, note);
	}
}

/*
	Name: _reacttoswarm
	Namespace: cybercom_gadget_firefly
	Checksum: 0xA0B31D42
	Offset: 0x39B0
	Size: 0x46C
	Parameters: 3
	Flags: Linked, Private
*/
function private _reacttoswarm(swarm, reactionanims, weapon)
{
	self endon(#"death");
	self thread _corpsewatcher(swarm);
	oldaware = self.badplaceawareness;
	self.badplaceawareness = 0.1;
	self.is_disabled = 1;
	self orientmode("face point", swarm.origin);
	self notify(#"hash_4457f945", swarm);
	level notify(#"hash_4457f945", self, swarm);
	if(self cybercom::function_421746e0())
	{
		self kill(self.origin, (isdefined(swarm.owner) ? swarm.owner : undefined));
		if(isdefined(swarm))
		{
			swarm notify(#"attack_stopped");
		}
		return;
	}
	if(!isalive(self) || self isragdoll())
	{
		return;
	}
	if(isdefined(reactionanims["intro"]))
	{
		self animscripted("swarm_intro_anim", self.origin, self.angles, reactionanims["intro"]);
		self thread cybercom::stopanimscriptedonnotify("damage", "swarm_intro_anim");
		self waittillmatch(#"swarm_intro_anim");
	}
	attack = 1;
	while(attack && isdefined(swarm))
	{
		self dodamage(5, self.origin, swarm.owner, swarm, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
		wait(0.05);
		self waittillmatch(#"bhtn_action_terminate");
		attack = isdefined(swarm) && (!(isdefined(swarm.dying_out) && swarm.dying_out)) && (distancesquared(self.origin + vectorscale((0, 0, 1), 48), swarm.origin)) < (getdvarint("scr_firefly_swarm_attack_radius", 110) * getdvarint("scr_firefly_swarm_attack_radius", 110)) && isalive(self);
	}
	self notify(#"attack_stopped", "specialpain", "end");
	if(isalive(self) && !self isragdoll())
	{
		self clientfield::set("firefly_state", 5);
		self.badplaceawareness = oldaware;
		self.swarm = undefined;
		self orientmode("face default");
		if(isdefined(reactionanims["outro"]))
		{
			self animscripted("swarm_outro_anim", self.origin, self.angles, reactionanims["outro"]);
			self thread cybercom::stopanimscriptedonnotify("damage", "swarm_outro_anim");
			self waittillmatch(#"swarm_outro_anim");
		}
		self.is_disabled = undefined;
	}
	if(isdefined(swarm))
	{
		swarm notify(#"attack_stopped", "end");
	}
}

/*
	Name: swarm_delete
	Namespace: cybercom_gadget_firefly
	Checksum: 0xBFE99AD4
	Offset: 0x3E28
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function swarm_delete()
{
	if(isdefined(self))
	{
		self notify(#"swarm_is_dead");
		if(isdefined(self.targetent) && !isplayer(self.targetent))
		{
			self.targetent clientfield::set("firefly_state", 5);
			self.targetent.swarm = undefined;
			self.targetent.swarm_coolofftime = gettime() + 2000;
		}
		level.cybercom.var_12f85dec--;
		achievements::function_b2d1aafa();
		self swarm_state_cleanup();
		self delete();
	}
}

/*
	Name: swarm_death_wait
	Namespace: cybercom_gadget_firefly
	Checksum: 0x1815D5B3
	Offset: 0x3F18
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function swarm_death_wait()
{
	self endon(#"death");
	while(gettime() < self.lifetime)
	{
		wait(1);
	}
	self.dying_out = 1;
	wait(2);
	self swarm_delete();
}

/*
	Name: swarm_dead_think
	Namespace: cybercom_gadget_firefly
	Checksum: 0x401B90A4
	Offset: 0x3F70
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function swarm_dead_think(params)
{
	self notify(#"swarm_is_dead");
	self endon(#"death");
	self clearforcedgoal();
	if(!self.firebugcount)
	{
		self clientfield::set("firefly_state", 5);
	}
	else
	{
		self clientfield::set("firefly_state", 10);
	}
	if(isdefined(self.targetent) && !isplayer(self.targetent))
	{
		self.targetent clientfield::set("firefly_state", 5);
		self.targetent.swarm = undefined;
		self.targetent.swarm_coolofftime = gettime() + 2000;
	}
	self vehicle::toggle_sounds(0);
	if(isdefined(self.owner))
	{
		self.owner notify(#"bhtn_action_notify", "firefly_end");
	}
	wait(3);
	self swarm_delete();
}

/*
	Name: swarm_main_think
	Namespace: cybercom_gadget_firefly
	Checksum: 0x1E0A005D
	Offset: 0x40D8
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function swarm_main_think(params)
{
	self endon(#"swarm_is_dead");
	self endon(#"death");
	if(isdefined(self.dying_out) && self.dying_out)
	{
		self.state_machine statemachine::set_state("dead");
		return;
	}
	self.debug.main++;
	if(!isdefined(self.targetent))
	{
		self.state_machine statemachine::set_state("hunt");
	}
	else
	{
		if((distancesquared(self.targetent.origin + vectorscale((0, 0, 1), 48), self.origin)) > (getdvarint("scr_firefly_swarm_attack_radius", 110) * getdvarint("scr_firefly_swarm_attack_radius", 110)))
		{
			self.state_machine statemachine::set_state("move");
		}
		else
		{
			self.state_machine statemachine::set_state("attack");
		}
	}
	self.debug.main--;
}

/*
	Name: _get_valid_targets
	Namespace: cybercom_gadget_firefly
	Checksum: 0x378BF8F3
	Offset: 0x4250
	Size: 0xF2
	Parameters: 0
	Flags: Linked, Private
*/
function private _get_valid_targets()
{
	humans = arraycombine(getaispeciesarray(self getenemyteam(), "human"), getaispeciesarray("team3", "human"), 0, 0);
	zombies = arraycombine(getaispeciesarray(self getenemyteam(), "zombie"), getaispeciesarray("team3", "zombie"), 0, 0);
	return arraycombine(humans, zombies, 0, 0);
}

/*
	Name: _lock_requirement
	Namespace: cybercom_gadget_firefly
	Checksum: 0xCD42BBF
	Offset: 0x4350
	Size: 0x1C8
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(isdefined(self.owner) && !self.owner cybercom::targetisvalid(target, getweapon("gadget_firefly_swarm")))
	{
		return false;
	}
	if(target.archetype != "human" && target.archetype != "human_riotshield" && target.archetype != "zombie" && target.archetype != "warlord")
	{
		return false;
	}
	if(target cybercom::cybercom_aicheckoptout("cybercom_fireflyswarm"))
	{
		return false;
	}
	if(isdefined(target.swarm))
	{
		return false;
	}
	if(isdefined(target.var_86386274))
	{
		if(target.var_86386274 > gettime())
		{
			return false;
		}
		target.var_86386274 = undefined;
	}
	if(isdefined(target.swarm_coolofftime) && gettime() < target.swarm_coolofftime)
	{
		return false;
	}
	if(isactor(target) && target cybercom::function_78525729() != "stand" && target cybercom::function_78525729() != "crouch")
	{
		return false;
	}
	return true;
}

/*
	Name: get_swarm_targetswithinfov
	Namespace: cybercom_gadget_firefly
	Checksum: 0x96F2D438
	Offset: 0x4520
	Size: 0x1A2
	Parameters: 4
	Flags: Linked
*/
function get_swarm_targetswithinfov(origin, angles, var_10a84c6e = getdvarint("scr_firefly_swarm_hunt_radius", 1536), nfor = cos(45))
{
	enemies = self _get_valid_targets();
	closetargets = arraysortclosest(enemies, origin, enemies.size, 0, var_10a84c6e);
	fovtargets = [];
	foreach(guy in closetargets)
	{
		if(!_lock_requirement(guy))
		{
			continue;
		}
		if(util::within_fov(origin, angles, guy.origin, nfor))
		{
			fovtargets[fovtargets.size] = guy;
		}
	}
	return fovtargets;
}

/*
	Name: swarm_find_good_target
	Namespace: cybercom_gadget_firefly
	Checksum: 0x1A5D1EB0
	Offset: 0x46D0
	Size: 0x224
	Parameters: 1
	Flags: Linked
*/
function swarm_find_good_target(var_10a84c6e = getdvarint("scr_firefly_swarm_hunt_radius", 1536))
{
	self endon(#"swarm_is_dead");
	self endon(#"death");
	enemies = self _get_valid_targets();
	closetargets = arraysortclosest(enemies, self.origin, enemies.size, 0, var_10a84c6e);
	closest = undefined;
	while(closetargets.size > 0)
	{
		closest = cybercom::getclosestto(self.origin, closetargets, var_10a84c6e);
		if(!_lock_requirement(closest))
		{
			arrayremovevalue(closetargets, closest, 0);
			closest = undefined;
			wait(0.05);
			continue;
		}
		if(!isdefined(closest))
		{
			break;
		}
		pathsuccess = 0;
		queryresult = positionquery_source_navigation(closest.origin, 0, 128, 128, 20, self);
		if(queryresult.data.size > 0)
		{
			pathsuccess = self findpath(self.origin, queryresult.data[0].origin, 1, 0);
		}
		if(!pathsuccess)
		{
			arrayremovevalue(closetargets, closest, 0);
			closest = undefined;
			wait(0.05);
			continue;
		}
		break;
	}
	return closest;
}

/*
	Name: swarm_hunt_think
	Namespace: cybercom_gadget_firefly
	Checksum: 0x3963BB96
	Offset: 0x4900
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function swarm_hunt_think(params)
{
	self endon(#"swarm_is_dead");
	self endon(#"death");
	self.debug.hunt++;
	self util::waittill_any_timeout(3, "near_goal");
	self clearforcedgoal();
	if(!self.firebugcount)
	{
		self clientfield::set("firefly_state", 1);
	}
	else
	{
		self clientfield::set("firefly_state", 6);
	}
	if(getdvarint("scr_firefly_swarm_debug", 0))
	{
		self thread cybercom::debug_circle(self.origin, getdvarint("scr_firefly_swarm_hunt_radius", 1536), 0.1, (1, 1, 0));
	}
	self.targetent = self swarm_find_good_target();
	if(isdefined(self.targetent))
	{
		self.targetent.swarm = self;
	}
	self.state_machine statemachine::set_state("main");
	self.debug.hunt--;
}

/*
	Name: swarm_move_think
	Namespace: cybercom_gadget_firefly
	Checksum: 0x6FE6DFCB
	Offset: 0x4AB0
	Size: 0x1BC
	Parameters: 1
	Flags: Linked
*/
function swarm_move_think(params)
{
	self endon(#"swarm_is_dead");
	self endon(#"death");
	self.debug.move++;
	if(!self.firebugcount)
	{
		self clientfield::set("firefly_state", 2);
	}
	else
	{
		self clientfield::set("firefly_state", 7);
	}
	wait(0.5);
	self.goalradius = 12;
	self.goalheight = 12;
	if(!self.firebugcount)
	{
		self clientfield::set("firefly_state", 3);
	}
	else
	{
		self clientfield::set("firefly_state", 8);
	}
	self clearforcedgoal();
	if(isdefined(self.targetent))
	{
		self setgoal(self.targetent.origin + vectorscale((0, 0, 1), 48), 1, self.goalradius);
		event = self util::waittill_any_timeout(30, "near_goal");
	}
	self.state_machine statemachine::set_state("main");
	self.debug.move--;
}

/*
	Name: fireflyplayereffect
	Namespace: cybercom_gadget_firefly
	Checksum: 0x259916C8
	Offset: 0x4C78
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function fireflyplayereffect(player)
{
	self endon(#"disconnect");
	player shellshock("proximity_grenade", 2, 0);
}

