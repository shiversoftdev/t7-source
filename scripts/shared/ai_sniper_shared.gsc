// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace ai_sniper;

/*
	Name: __init__sytem__
	Namespace: ai_sniper
	Checksum: 0x23D78D65
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ai_sniper", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ai_sniper
	Checksum: 0xD1F6A6ED
	Offset: 0x240
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	thread init_node_scan();
}

/*
	Name: init_node_scan
	Namespace: ai_sniper
	Checksum: 0x1086FD21
	Offset: 0x260
	Size: 0x326
	Parameters: 1
	Flags: Linked
*/
function init_node_scan(targetname)
{
	wait(0.05);
	if(!isdefined(targetname))
	{
		targetname = "ai_sniper_node_scan";
	}
	structlist = struct::get_array(targetname, "targetname");
	pointlist = getentarray(targetname, "targetname");
	foreach(struct in structlist)
	{
		pointlist[pointlist.size] = struct;
	}
	foreach(point in pointlist)
	{
		if(isdefined(point.target))
		{
			node = getnode(point.target, "targetname");
			if(isdefined(node))
			{
				if(!isdefined(node.lase_points))
				{
					node.lase_points = [];
				}
				node.lase_points[node.lase_points.size] = point;
			}
		}
	}
	var_69cb4035 = getnodearray(targetname, "script_noteworthy");
	foreach(node in var_69cb4035)
	{
		if(isdefined(node.script_linkto))
		{
			node.var_57357d16 = struct::get(node.script_linkto, "script_linkname");
			if(!isdefined(node.var_57357d16))
			{
				node.var_57357d16 = getent(node.script_linkto, "script_linkname");
			}
		}
	}
}

/*
	Name: agent_init
	Namespace: ai_sniper
	Checksum: 0x78564A6B
	Offset: 0x590
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function agent_init()
{
	self thread patrol_lase_goal_waiter();
	self thread function_6a517a0a();
	self thread function_6fb6a6d3();
}

/*
	Name: function_b61dfa9e
	Namespace: ai_sniper
	Checksum: 0x8EFF84FE
	Offset: 0x5E8
	Size: 0x132
	Parameters: 1
	Flags: Linked
*/
function function_b61dfa9e(node)
{
	if(!isdefined(node))
	{
		return;
	}
	if(!isdefined(node.lase_points) && !isdefined(node.var_57357d16))
	{
		return;
	}
	self notify(#"hash_b61dfa9e");
	self endon(#"hash_b61dfa9e");
	self endon(#"death");
	self endon(#"lase_points");
	if(isdefined(self.patroller) && self.patroller)
	{
		self ai::end_and_clean_patrol_behaviors();
	}
	goalpos = node.origin;
	if(isdefined(self.pathgoalpos))
	{
		goalpos = self.pathgoalpos;
	}
	if(isdefined(self.arrivalfinalpos))
	{
		goalpos = self.arrivalfinalpos;
	}
	while(distancesquared(self.origin, goalpos) > 256)
	{
		wait(0.05);
	}
	self notify(#"hash_50b88a46", node);
}

/*
	Name: function_6a517a0a
	Namespace: ai_sniper
	Checksum: 0x31DC4EDB
	Offset: 0x728
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function function_6a517a0a()
{
	self notify(#"hash_6a517a0a");
	self endon(#"hash_6a517a0a");
	self endon(#"death");
	while(true)
	{
		self waittill(#"patrol_goal", node);
		self function_b61dfa9e(node);
	}
}

/*
	Name: function_6fb6a6d3
	Namespace: ai_sniper
	Checksum: 0x94B80BDB
	Offset: 0x798
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_6fb6a6d3()
{
	self notify(#"hash_6fb6a6d3");
	self endon(#"hash_6fb6a6d3");
	self endon(#"death");
	if(isdefined(self.target) && (!(isdefined(self.patroller) && self.patroller)))
	{
		node = getnode(self.target, "targetname");
		if(isdefined(node))
		{
			self waittill(#"goal");
			self function_b61dfa9e(node);
		}
	}
}

/*
	Name: patrol_lase_goal_waiter
	Namespace: ai_sniper
	Checksum: 0x549EAA89
	Offset: 0x858
	Size: 0x278
	Parameters: 0
	Flags: Linked
*/
function patrol_lase_goal_waiter()
{
	self notify(#"patrol_lase_goal_waiter");
	self endon(#"patrol_lase_goal_waiter");
	self endon(#"death");
	while(true)
	{
		was_stealth = 0;
		self waittill(#"hash_50b88a46", node);
		if(isdefined(node.var_57357d16))
		{
			self thread actor_lase_points_behavior(node.var_57357d16);
		}
		else
		{
			self thread actor_lase_points_behavior(node.lase_points);
		}
		if(self ai::has_behavior_attribute("stealth"))
		{
			was_stealth = self ai::get_behavior_attribute("stealth");
			self ai::set_behavior_attribute("stealth", 0);
		}
		if(isdefined(self.currentgoal) && isdefined(self.currentgoal.target) && self.currentgoal.target != "")
		{
			self setgoal(node, 1);
			self waittill(#"lase_points_loop");
			self notify(#"lase_points");
			self laseroff();
			self.holdfire = 0;
			self ai::stop_shoot_at_target();
			if(isdefined(self.var_d1ddf246))
			{
				self.goalradius = self.var_d1ddf246;
				self.var_d1ddf246 = undefined;
			}
			if(isdefined(self.currentgoal))
			{
				self thread ai::patrol(self.currentgoal);
			}
			if(was_stealth && self ai::has_behavior_attribute("stealth"))
			{
				self ai::set_behavior_attribute("stealth", self.awarenesslevelcurrent != "combat");
			}
		}
		else
		{
			break;
		}
	}
}

/*
	Name: actor_lase_points_behavior
	Namespace: ai_sniper
	Checksum: 0x1808EB64
	Offset: 0xAD8
	Size: 0x314
	Parameters: 1
	Flags: Linked
*/
function actor_lase_points_behavior(entity_or_point_array)
{
	self notify(#"lase_points");
	self endon(#"lase_points");
	self endon(#"death");
	self.holdfire = 1;
	self.blindaim = 1;
	if(!isdefined(self.var_d1ddf246))
	{
		self.var_d1ddf246 = self.goalradius;
	}
	self.goalradius = 8;
	if(isdefined(self.__blackboard) && isdefined(self.script_parameters) && self.script_parameters == "steady")
	{
		blackboard::setblackboardattribute(self, "_context", "steady");
	}
	if(!isdefined(entity_or_point_array) && isdefined(self.target))
	{
		entity_or_point_array = struct::get(self.target, "targetname");
	}
	if(!isdefined(entity_or_point_array) || (isarray(entity_or_point_array) && entity_or_point_array.size == 0))
	{
		/#
			iprintlnbold("");
		#/
		return;
	}
	var_978eac89 = undefined;
	if(isarray(entity_or_point_array))
	{
		var_978eac89 = entity_or_point_array[0];
	}
	else
	{
		var_978eac89 = entity_or_point_array;
	}
	if(!isdefined(self.lase_ent))
	{
		self.lase_ent = spawn("script_model", lase_point(var_978eac89));
		self.lase_ent setmodel("tag_origin");
		self.lase_ent.velocity = vectorscale((1, 0, 0), 100);
		self thread util::delete_on_death(self.lase_ent);
	}
	if(self.lase_ent.health <= 0)
	{
		self.lase_ent.health = 1;
	}
	self thread ai::shoot_at_target("shoot_until_target_dead", self.lase_ent);
	self.lase_ent thread target_lase_points(entity_or_point_array, self);
	self.lase_ent thread target_lase_points_ally_track(self geteye(), entity_or_point_array, self);
	self thread actor_lase_force_laser_on();
	self thread function_659cb4db();
}

/*
	Name: actor_lase_stop
	Namespace: ai_sniper
	Checksum: 0x89504E76
	Offset: 0xDF8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function actor_lase_stop()
{
	if(!isdefined(self.lase_ent))
	{
		return;
	}
	self notify(#"lase_points");
	self.holdfire = 0;
	self.blindaim = 0;
	self.lase_ent delete();
	self.lase_ent = undefined;
	self clearentitytarget();
	if(isdefined(self.var_d1ddf246))
	{
		self.goalradius = self.var_d1ddf246;
		self.var_d1ddf246 = undefined;
	}
	self laseroff();
	if(isdefined(self.__blackboard))
	{
		blackboard::setblackboardattribute(self, "_context", undefined);
	}
}

/*
	Name: debug_position
	Namespace: ai_sniper
	Checksum: 0x4B2AA06C
	Offset: 0xED0
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function debug_position()
{
	/#
		self endon(#"death");
		lastpos = self.origin;
		while(true)
		{
			debugstar(self.origin, 1, (1, 0, 0));
			line(self.origin, lastpos, (1, 0, 0), 1, 0, 20);
			lastpos = self.origin;
			wait(0.05);
		}
	#/
}

/*
	Name: actor_lase_force_laser_on
	Namespace: ai_sniper
	Checksum: 0xC637A92F
	Offset: 0xF70
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function actor_lase_force_laser_on()
{
	self endon(#"death");
	self endon(#"lase_points");
	var_bef987c0 = gettime();
	while(true)
	{
		if(self asmistransdecrunning())
		{
			var_bef987c0 = gettime();
			self laseroff();
		}
		else if((gettime() - var_bef987c0) > 350)
		{
			self laseron();
		}
		wait(0.05);
	}
}

/*
	Name: function_659cb4db
	Namespace: ai_sniper
	Checksum: 0x6F5C83B3
	Offset: 0x1010
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_659cb4db()
{
	self endon(#"lase_points");
	self waittill(#"death");
	if(isdefined(self))
	{
		self laseroff();
	}
}

/*
	Name: lase_point
	Namespace: ai_sniper
	Checksum: 0xCE81701A
	Offset: 0x1058
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function lase_point(entity_or_point)
{
	if(!isdefined(entity_or_point))
	{
		return (0, 0, 0);
	}
	result = entity_or_point;
	if(!isvec(entity_or_point) && isdefined(entity_or_point.origin))
	{
		result = entity_or_point.origin;
		if(isplayer(entity_or_point) || isactor(entity_or_point))
		{
			result = entity_or_point geteye();
		}
	}
	return result;
}

/*
	Name: target_lase_points_ally_track
	Namespace: ai_sniper
	Checksum: 0x47C57FA9
	Offset: 0x1120
	Size: 0x3C8
	Parameters: 3
	Flags: Linked
*/
function target_lase_points_ally_track(v_eye, entity_or_point_array, a_owner)
{
	self notify(#"actor_lase_points_player_track");
	self endon(#"actor_lase_points_player_track");
	self endon(#"death");
	if(!isdefined(level.var_b8032721))
	{
		level.var_b8032721 = [];
	}
	if(!isdefined(level.var_2b420add))
	{
		level.var_2b420add = 0;
	}
	while(true)
	{
		var_6121992f = vectornormalize(self.origin - v_eye);
		if(gettime() > level.var_2b420add)
		{
			level.var_b8032721 = getplayers();
			actorlist = getaiteamarray("allies");
			foreach(actor in actorlist)
			{
				if(isdefined(actor.ignoreme) && actor.ignoreme)
				{
					continue;
				}
				if(isalive(actor))
				{
					level.var_b8032721[level.var_b8032721.size] = actor;
				}
			}
			level.var_2b420add = gettime() + 1000;
		}
		for(i = 0; i < level.var_b8032721.size; i++)
		{
			ally = level.var_b8032721[i];
			if(!isalive(ally))
			{
				continue;
			}
			if(ally isnotarget() || (isdefined(ally.ignoreme) && ally.ignoreme))
			{
				continue;
			}
			var_633cfa62 = lase_point(ally);
			var_c4827684 = vectornormalize(var_633cfa62 - v_eye);
			if(vectordot(var_6121992f, var_c4827684) < 0.7)
			{
				continue;
			}
			var_6a3f5d89 = pointonsegmentnearesttopoint(v_eye, self.origin, var_633cfa62);
			if(distancesquared(var_633cfa62, var_6a3f5d89) < 40000)
			{
				if(sighttracepassed(v_eye, var_633cfa62, 0, undefined))
				{
					if(isdefined(a_owner))
					{
						a_owner notify(#"alert", "combat", var_633cfa62, ally);
					}
					self function_b77b41d1(v_eye, ally, a_owner);
					break;
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_b77b41d1
	Namespace: ai_sniper
	Checksum: 0x7AED1337
	Offset: 0x14F0
	Size: 0xAC
	Parameters: 4
	Flags: Linked
*/
function function_b77b41d1(v_eye, entity_or_point, a_owner, var_12065f0b = 1)
{
	sight_timeout = 7;
	if(isdefined(self.a_owner) && isdefined(self.a_owner.var_815502c4))
	{
		sight_timeout = self.a_owner.var_815502c4;
	}
	self target_lase_override(v_eye, entity_or_point, sight_timeout, a_owner, 1, var_12065f0b);
}

/*
	Name: target_lase_points
	Namespace: ai_sniper
	Checksum: 0x4E7EBBFE
	Offset: 0x15A8
	Size: 0x288
	Parameters: 2
	Flags: Linked
*/
function target_lase_points(entity_or_point_array, e_owner)
{
	self notify(#"lase_points");
	self endon(#"lase_points");
	self endon(#"death");
	pausetime = randomfloatrange(2, 4);
	if(isarray(entity_or_point_array) && entity_or_point_array.size <= 0)
	{
		return;
	}
	index = 0;
	start = entity_or_point_array;
	while(true)
	{
		while(isdefined(self.lase_override))
		{
			wait(0.05);
			continue;
		}
		if(isarray(entity_or_point_array))
		{
			self target_lase_transition(entity_or_point_array[index], e_owner);
			if(!isvec(entity_or_point_array[index]) && isdefined(entity_or_point_array[index].script_wait))
			{
				wait(entity_or_point_array[index].script_wait);
			}
		}
		else
		{
			entity_or_point_array = target_lase_next(entity_or_point_array);
			self target_lase_transition(entity_or_point_array, e_owner);
			if(!isvec(entity_or_point_array) && isdefined(entity_or_point_array.script_wait))
			{
				wait(entity_or_point_array.script_wait);
			}
		}
		looped = 0;
		if(isarray(entity_or_point_array))
		{
			index = index + 1;
			if(index >= entity_or_point_array.size)
			{
				index = 0;
				looped = 1;
			}
		}
		else if(entity_or_point_array == start)
		{
			looped = 1;
		}
		if(looped)
		{
			self notify(#"lase_points_loop");
			if(isdefined(e_owner))
			{
				e_owner notify(#"lase_points_loop");
			}
		}
	}
}

/*
	Name: function_9c1ac1cb
	Namespace: ai_sniper
	Checksum: 0x148C09E1
	Offset: 0x1838
	Size: 0x3BC
	Parameters: 3
	Flags: Linked
*/
function function_9c1ac1cb(endposition, totaltime, var_5d61a864)
{
	self notify(#"hash_9c1ac1cb");
	self endon(#"hash_9c1ac1cb");
	self endon(#"death");
	startposition = self.origin;
	var_e651c736 = self.velocity;
	var_c8240fdb = vectornormalize(self.velocity);
	var_ed017668 = totaltime * 4;
	phase = length(self.velocity) / (var_ed017668 * 2);
	starttime = gettime();
	var_ea09f212 = totaltime * 1000;
	var_1632b53d = var_ea09f212 * 0.75;
	notified = 0;
	var_3d372c1a = 65000;
	if(!isdefined(var_5d61a864) || var_5d61a864)
	{
		self endon(#"hash_9744842a");
	}
	while((gettime() - starttime) < var_ea09f212)
	{
		if(!notified && (gettime() - starttime) > var_1632b53d)
		{
			self notify(#"hash_9744842a");
			notified = 1;
		}
		deltatime = (float(gettime() - starttime)) / 1000;
		var_67fe8eb1 = min(deltatime, var_ed017668);
		var_e42cf565 = startposition + (var_e651c736 * var_67fe8eb1);
		var_7a592a87 = var_e42cf565 + ((((var_c8240fdb * phase) * -0.5) * var_67fe8eb1) * var_67fe8eb1);
		var_60941c0a = deltatime / totaltime;
		var_60941c0a = 1 - (0.5 + ((cos(var_60941c0a * 180)) * 0.5));
		var_515ca7cf = endposition;
		/#
			assert(isdefined(var_515ca7cf));
		#/
		neworigin = vectorlerp(var_7a592a87, var_515ca7cf, var_60941c0a);
		self.velocity = (neworigin - self.origin) / 0.05;
		if(neworigin[0] > (var_3d372c1a * -1) && neworigin[0] < var_3d372c1a && neworigin[1] > (var_3d372c1a * -1) && neworigin[1] < var_3d372c1a && neworigin[2] > (var_3d372c1a * -1) && neworigin[2] < var_3d372c1a)
		{
			self.origin = neworigin;
		}
		wait(0.05);
	}
}

/*
	Name: target_lase_next
	Namespace: ai_sniper
	Checksum: 0x2CA68A2C
	Offset: 0x1C00
	Size: 0x180
	Parameters: 1
	Flags: Linked
*/
function target_lase_next(node)
{
	if(!isdefined(node))
	{
		return undefined;
	}
	var_e236c887 = undefined;
	var_702f594c = undefined;
	if(isdefined(node.target) && isdefined(node.script_linkto))
	{
		var_e236c887 = struct::get(node.target, "targetname");
		var_702f594c = struct::get(node.script_linkto, "script_linkname");
	}
	else
	{
		if(isdefined(node.target))
		{
			var_e236c887 = struct::get(node.target, "targetname");
		}
		else if(isdefined(node.script_linkto))
		{
			var_e236c887 = struct::get(node.script_linkto, "script_linkname");
		}
	}
	if(isdefined(var_e236c887) && isdefined(var_702f594c))
	{
		if(randomfloatrange(0, 1) < 0.5)
		{
			return var_e236c887;
		}
		return var_702f594c;
	}
	return var_e236c887;
}

/*
	Name: target_lase_transition
	Namespace: ai_sniper
	Checksum: 0x9EA054B1
	Offset: 0x1D88
	Size: 0x1D8
	Parameters: 2
	Flags: Linked
*/
function target_lase_transition(entity_or_point, owner)
{
	self notify(#"target_lase_transition");
	self endon(#"target_lase_transition");
	self endon(#"death");
	if(isentity(entity_or_point))
	{
		entity_or_point endon(#"death");
		while(true)
		{
			point = lase_point(entity_or_point);
			delta = point - self.origin;
			delta = delta * 0.2;
			self.origin = self.origin + delta;
			wait(0.05);
		}
	}
	else
	{
		speed = 200;
		point = lase_point(entity_or_point);
		time = distance(point, self.origin) / speed;
		var_779fd53f = 0;
		if(isdefined(owner) && isdefined(owner.var_26c21ea3))
		{
			var_779fd53f = 1;
			time = min(time, owner.var_26c21ea3);
		}
		if(time > 0)
		{
			self thread function_9c1ac1cb(point, time, var_779fd53f);
			self waittill(#"hash_9744842a");
		}
	}
}

/*
	Name: target_lase_override
	Namespace: ai_sniper
	Checksum: 0xE14A5317
	Offset: 0x1F68
	Size: 0x272
	Parameters: 6
	Flags: Linked
*/
function target_lase_override(v_eye, entity_or_point, sight_timeout, a_owner, fire_weapon, var_12065f0b = 1)
{
	if(isdefined(self.lase_override) && (!var_12065f0b || self.lase_override == entity_or_point))
	{
		return;
	}
	self notify(#"target_lase_override");
	self endon(#"target_lase_override");
	self endon(#"death");
	self.lase_override = entity_or_point;
	self thread target_lase_transition(entity_or_point, a_owner);
	outofsighttime = 0;
	var_4bbe1b92 = 0;
	var_94a708a2 = 0;
	if(isdefined(a_owner.var_dfa3c2cb))
	{
		var_94a708a2 = a_owner.var_dfa3c2cb;
	}
	if(!isdefined(fire_weapon))
	{
		fire_weapon = 1;
	}
	while(true)
	{
		if(var_4bbe1b92 >= var_94a708a2)
		{
			if(isactor(a_owner))
			{
				a_owner.holdfire = !fire_weapon;
				if(fire_weapon)
				{
					a_owner.var_8c2ddc6 = gettime();
				}
			}
		}
		if(!isdefined(entity_or_point) || outofsighttime >= sight_timeout)
		{
			self notify(#"target_lase_transition");
			break;
		}
		if(!sighttracepassed(v_eye, lase_point(entity_or_point), 0, undefined))
		{
			outofsighttime = outofsighttime + 0.05;
		}
		else
		{
			outofsighttime = 0;
		}
		var_4bbe1b92 = var_4bbe1b92 + 0.05;
		wait(0.05);
	}
	if(isactor(a_owner))
	{
		a_owner.holdfire = 1;
	}
	self.lase_override = undefined;
}

/*
	Name: is_firing
	Namespace: ai_sniper
	Checksum: 0x62D49F3A
	Offset: 0x21E8
	Size: 0x46
	Parameters: 1
	Flags: None
*/
function is_firing(a_owner)
{
	if(!isdefined(a_owner))
	{
		return 0;
	}
	if(!isdefined(a_owner.var_8c2ddc6))
	{
		return 0;
	}
	return (gettime() - a_owner.var_8c2ddc6) < 3000;
}

