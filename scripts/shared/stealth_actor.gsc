// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_behavior;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_event;
#using scripts\shared\stealth_status;
#using scripts\shared\stealth_tagging;
#using scripts\shared\stealth_vo;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace stealth_actor;

/*
	Name: init
	Namespace: stealth_actor
	Checksum: 0xA1840353
	Offset: 0x2F0
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		assert(isactor(self));
	#/
	if(!(isdefined(self.script_stealth) && self.script_stealth) && (!(isdefined(self.var_64f4c3f) && self.var_64f4c3f)) && (!(isdefined(self.script_stealth_dontseek) && self.script_stealth_dontseek)))
	{
		return;
	}
	if(isdefined(self.stealth))
	{
		return;
	}
	if(!isdefined(self.stealth))
	{
		self.stealth = spawnstruct();
	}
	self.stealth.enabled_actor = 1;
	self function_a860a2eb();
	self stealth_status::init();
	self stealth_aware::init();
	self stealth_event::init();
	self stealth_tagging::init();
	self stealth_vo::init();
	self.overrideactordamage = &function_ebcb7adc;
	/#
		self stealth_debug::init_debug();
	#/
	if(isdefined(self.var_64f4c3f) && self.var_64f4c3f || (isdefined(self.script_stealth_dontseek) && self.script_stealth_dontseek))
	{
		self thread function_39fb9593();
	}
}

/*
	Name: stop
	Namespace: stealth_actor
	Checksum: 0xB8AD0EF9
	Offset: 0x4B8
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function stop()
{
	if(self stealth_aware::enabled())
	{
		self stealth_aware::set_awareness("combat");
		self.stealth.investigating = undefined;
		foreach(player in level.activeplayers)
		{
			self setignoreent(player, 0);
		}
		self stealth_status::function_180adb28();
	}
}

/*
	Name: reset
	Namespace: stealth_actor
	Checksum: 0xF8BBF25
	Offset: 0x5B0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function reset()
{
	if(self stealth_aware::enabled())
	{
		self stealth_aware::set_awareness("unaware");
	}
}

/*
	Name: enabled
	Namespace: stealth_actor
	Checksum: 0x7E18699C
	Offset: 0x5F8
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function enabled()
{
	return isdefined(self.stealth) && isdefined(self.stealth.enabled_actor);
}

/*
	Name: function_a860a2eb
	Namespace: stealth_actor
	Checksum: 0xE1BFA2FC
	Offset: 0x620
	Size: 0x17E
	Parameters: 0
	Flags: Linked
*/
function function_a860a2eb()
{
	entnum = self getentitynumber();
	if(isdefined(self.stealth) && !isdefined(self.stealth.var_fd87ae1c) && (!isdefined(self.___archetypeonanimscriptedcallback) || self.___archetypeonanimscriptedcallback != (&function_a880fdea)))
	{
		self.stealth.var_fd87ae1c = self.___archetypeonanimscriptedcallback;
	}
	self.___archetypeonanimscriptedcallback = &function_a880fdea;
	switch(entnum % 4)
	{
		case 1:
		{
			blackboard::setblackboardattribute(self, "_context2", "v2");
			break;
		}
		case 2:
		{
			blackboard::setblackboardattribute(self, "_context2", "v3");
			break;
		}
		case 3:
		{
			blackboard::setblackboardattribute(self, "_context2", "v4");
			break;
		}
		default:
		{
			blackboard::setblackboardattribute(self, "_context2", "v1");
			break;
		}
	}
}

/*
	Name: function_a880fdea
	Namespace: stealth_actor
	Checksum: 0x7598875C
	Offset: 0x7A8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_a880fdea(entity)
{
	if(isdefined(entity.stealth) && isdefined(entity.stealth.var_fd87ae1c))
	{
		[[entity.stealth.var_fd87ae1c]](entity);
	}
	entity function_a860a2eb();
}

/*
	Name: function_ebcb7adc
	Namespace: stealth_actor
	Checksum: 0xD014DB9C
	Offset: 0x828
	Size: 0x106
	Parameters: 13
	Flags: Linked
*/
function function_ebcb7adc(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname)
{
	if(self.awarenesslevelcurrent != "combat" && idamage > 10)
	{
		myeye = self geteye();
		if(isplayer(einflictor) && isdefined(vpoint) && distancesquared(vpoint, myeye) < 100)
		{
			return self.health + 1;
		}
	}
	return idamage;
}

/*
	Name: function_39fb9593
	Namespace: stealth_actor
	Checksum: 0x7C26EE53
	Offset: 0x938
	Size: 0x2E0
	Parameters: 0
	Flags: Linked
*/
function function_39fb9593()
{
	self notify(#"hash_39fb9593");
	self endon(#"hash_39fb9593");
	self endon(#"death");
	self.var_75a707ea = 1;
	if(!(isdefined(self.script_stealth_dontseek) && self.script_stealth_dontseek))
	{
		self function_77ae41ed(1);
		if(self ai::has_behavior_attribute("sprint"))
		{
			self ai::set_behavior_attribute("sprint", 1);
		}
		if(self ai::has_behavior_attribute("traversals"))
		{
			self ai::set_behavior_attribute("traversals", "procedural");
		}
	}
	self thread function_8be8b843();
	if(level flag::get("stealth_discovered") && getdvarint("stealth_no_return"))
	{
		wait(0.05);
		self stealth::stop();
		return;
	}
	wait(1);
	self thread function_517ba9d2();
	self thread function_56e538df();
	while(true)
	{
		self waittill(#"hash_3dce0f1d", str_awareness);
		if(!self enabled() || !isdefined(level.stealth) || !isdefined(level.stealth.seek))
		{
			return;
		}
		if(str_awareness != "combat")
		{
			self notify(#"investigate", self.origin, undefined, "infinite");
		}
		else if(str_awareness == "combat")
		{
			foreach(combatant in level.stealth.seek)
			{
				stealth_aware::enter_combat_with(combatant);
			}
			self stealth_behavior::investigate_stop();
		}
	}
}

/*
	Name: function_8be8b843
	Namespace: stealth_actor
	Checksum: 0xDAB89D53
	Offset: 0xC20
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function function_8be8b843()
{
	self endon(#"hash_39fb9593");
	self endon(#"death");
	while(true)
	{
		foreach(player in level.activeplayers)
		{
			self getperfectinfo(player, 1);
			if(self stealth_aware::enabled())
			{
				self stealth_aware::enter_combat_with(player);
			}
		}
		self clearforcedgoal();
		self cleargoalvolume();
		wait(1);
	}
}

/*
	Name: function_517ba9d2
	Namespace: stealth_actor
	Checksum: 0x21A91E59
	Offset: 0xD40
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function function_517ba9d2()
{
	self endon(#"hash_39fb9593");
	self endon(#"death");
	while(true)
	{
		self waittill(#"awareness", str_awareness);
		self notify(#"hash_3dce0f1d", str_awareness);
	}
}

/*
	Name: function_56e538df
	Namespace: stealth_actor
	Checksum: 0x49E35DF1
	Offset: 0xDA0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_56e538df()
{
	self endon(#"hash_39fb9593");
	self endon(#"death");
	while(true)
	{
		level flag::wait_till("stealth_combat");
		self notify(#"hash_3dce0f1d", "combat");
		level flag::wait_till_clear("stealth_combat");
	}
}

/*
	Name: function_1064f733
	Namespace: stealth_actor
	Checksum: 0x93FC16D4
	Offset: 0xE18
	Size: 0x2DE
	Parameters: 0
	Flags: Linked
*/
function function_1064f733()
{
	self notify(#"hash_1064f733");
	self endon(#"hash_1064f733");
	self endon(#"death");
	if(isdefined(self.var_75a707ea) && self.var_75a707ea)
	{
		return;
	}
	if(isdefined(self.var_1064f733) && self.var_1064f733)
	{
		return;
	}
	self.var_1064f733 = 1;
	nosighttime = 0;
	wait(randomfloatrange(0.1, 3));
	while(true)
	{
		var_a21c667 = 0;
		foreach(player in level.activeplayers)
		{
			if(self cansee(player))
			{
				nosighttime = 0;
				var_a21c667 = 1;
				break;
			}
		}
		if(!var_a21c667)
		{
			nosighttime = nosighttime + 1;
		}
		if(nosighttime >= 8)
		{
			foreach(player in level.activeplayers)
			{
				self getperfectinfo(player, 1);
			}
			self clearforcedgoal();
			self cleargoalvolume();
			self function_77ae41ed(1);
			if(self ai::has_behavior_attribute("sprint"))
			{
				self ai::set_behavior_attribute("sprint", 1);
			}
		}
		else
		{
			self function_77ae41ed(0);
			if(self ai::has_behavior_attribute("sprint"))
			{
				self ai::set_behavior_attribute("sprint", 0);
			}
		}
		wait(1);
	}
}

/*
	Name: function_77ae41ed
	Namespace: stealth_actor
	Checksum: 0xB2C0817
	Offset: 0x1100
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_77ae41ed(var_e0824a47)
{
	if(var_e0824a47)
	{
		if(self ai::has_behavior_attribute("move_mode"))
		{
			if(self ai::has_behavior_attribute("can_become_rusher") && self ai::get_behavior_attribute("can_become_rusher"))
			{
				self ai::set_behavior_attribute("move_mode", "rusher");
			}
			else
			{
				self ai::set_behavior_attribute("move_mode", "rambo");
			}
		}
	}
	else if(self ai::has_behavior_attribute("move_mode"))
	{
		self ai::set_behavior_attribute("move_mode", "normal");
	}
}

