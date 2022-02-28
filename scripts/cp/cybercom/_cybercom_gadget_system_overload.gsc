// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace cybercom_gadget_system_overload;

/*
	Name: init
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x99EC1590
	Offset: 0x590
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_gadget_system_overload
	Checksum: 0xFA91966B
	Offset: 0x5A0
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(0, 1);
	level.cybercom.system_overload = spawnstruct();
	level.cybercom.system_overload._is_flickering = &_is_flickering;
	level.cybercom.system_overload._on_flicker = &_on_flicker;
	level.cybercom.system_overload._on_give = &_on_give;
	level.cybercom.system_overload._on_take = &_on_take;
	level.cybercom.system_overload._on_connect = &_on_connect;
	level.cybercom.system_overload._on = &_on;
	level.cybercom.system_overload._off = &_off;
	level.cybercom.system_overload._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_system_overload
	Checksum: 0xB8B6B934
	Offset: 0x728
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x1056D238
	Offset: 0x740
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x326F4A20
	Offset: 0x760
	Size: 0x154
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.var_110c156a = getdvarint("scr_system_overload_count", 3);
	self.cybercom.system_overload_lifetime = getdvarfloat("scr_system_overload_lifetime", 6.3) * 1000;
	if(self hascybercomability("cybercom_systemoverload") == 2)
	{
		self.cybercom.var_110c156a = getdvarint("scr_system_overload_upgraded_count", 5);
		self.cybercom.system_overload_lifetime = getdvarfloat("scr_system_overload_upgraded_lifetime", 6.3) * 1000;
	}
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self thread cybercom::function_b5f4e597(weapon);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_system_overload
	Checksum: 0xEC35A07C
	Offset: 0x8C0
	Size: 0x62
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
	self _off(slot, weapon);
	self.cybercom.is_primed = undefined;
	self.cybercom.targetlockcb = undefined;
	self.cybercom.targetlockrequirementcb = undefined;
}

/*
	Name: _on_connect
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x99EC1590
	Offset: 0x930
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x3EBDA224
	Offset: 0x940
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	self thread _activate_system_overload(slot, weapon);
	self _off(slot, weapon);
}

/*
	Name: _off
	Namespace: cybercom_gadget_system_overload
	Checksum: 0xD572B556
	Offset: 0x9A0
	Size: 0x46
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
	self thread cybercom::weaponendlockwatcher(weapon);
	self.cybercom.is_primed = undefined;
	self notify(#"hash_8e37d611");
}

/*
	Name: _is_primed
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x49BDBE16
	Offset: 0x9F0
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function _is_primed(slot, weapon)
{
	if(!(isdefined(self.cybercom.is_primed) && self.cybercom.is_primed))
	{
		/#
			assert(self.cybercom.activecybercomweapon == weapon);
		#/
		self notify(#"hash_eec19461");
		self thread cybercom::weaponlockwatcher(slot, weapon, self.cybercom.var_110c156a);
		self.cybercom.is_primed = 1;
	}
}

/*
	Name: _lock_requirement
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x5E11D271
	Offset: 0xAA8
	Size: 0x238
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(!isdefined(target))
	{
		return false;
	}
	if(target cybercom::cybercom_aicheckoptout("cybercom_systemoverload"))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(isdefined(target.hijacked) && target.hijacked)
	{
		self cybercom::function_29bf9dee(target, 4);
		return false;
	}
	if(isdefined(target.is_disabled) && target.is_disabled)
	{
		self cybercom::function_29bf9dee(target, 6);
		return false;
	}
	if(isactor(target) && target cybercom::function_78525729() != "stand" && target cybercom::function_78525729() != "crouch")
	{
		return false;
	}
	if(isactor(target) && target.archetype != "robot")
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(!isactor(target) && !isvehicle(target))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(isactor(target) && !target isonground() && !target cybercom::function_421746e0())
	{
		return false;
	}
	return true;
}

/*
	Name: _get_valid_targets
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x6B564225
	Offset: 0xCE8
	Size: 0x52
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	return arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
}

/*
	Name: _activate_system_overload
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x80F2E8F1
	Offset: 0xD48
	Size: 0x2AC
	Parameters: 2
	Flags: Linked, Private
*/
function private _activate_system_overload(slot, weapon)
{
	aborted = 0;
	fired = 0;
	foreach(item in self.cybercom.lock_targets)
	{
		if(isdefined(item.target) && (isdefined(item.inrange) && item.inrange))
		{
			if(item.inrange == 1)
			{
				if(!cybercom::targetisvalid(item.target, weapon))
				{
					continue;
				}
				self thread challenges::function_96ed590f("cybercom_uses_control");
				item.target thread system_overload(self, undefined, weapon);
				fired++;
				continue;
			}
			if(item.inrange == 2)
			{
				aborted++;
			}
		}
	}
	if(aborted && !fired)
	{
		self.cybercom.lock_targets = [];
		self cybercom::function_29bf9dee(undefined, 1, 0);
	}
	cybercom::function_adc40f11(weapon, fired);
	if(fired && isplayer(self))
	{
		itemindex = getitemindexfromref("cybercom_systemoverload");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "assists", "statValue", fired);
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: _system_overload_vehicle
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x7EDEB03F
	Offset: 0x1000
	Size: 0x12C
	Parameters: 2
	Flags: Linked, Private
*/
function private _system_overload_vehicle(attacker, weapon)
{
	if(isdefined(self.var_7c04bee3) && gettime() < self.var_7c04bee3)
	{
		return;
	}
	self clientfield::set("cybercom_sysoverload", 1);
	self stopsounds();
	damage = 5;
	if(isdefined(self.archetype))
	{
		if(self.archetype == "wasp")
		{
			damage = 25;
		}
	}
	self dodamage(damage, self.origin, attacker, undefined, "none", "MOD_GRENADE_SPLASH", 0, getweapon("emp_grenade"), -1, 1);
	self.var_7c04bee3 = gettime() + (getdvarint("scr_system_overload_vehicle_cooldown_seconds", 5) * 1000);
}

/*
	Name: ai_activatesystemoverload
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x49C03469
	Offset: 0x1138
	Size: 0x2C2
	Parameters: 3
	Flags: Linked
*/
function ai_activatesystemoverload(target, var_9bc2efcb = 1, disabletimemsec)
{
	if(!isdefined(target))
	{
		return;
	}
	if(self.archetype != "human")
	{
		return;
	}
	validtargets = [];
	if(isarray(target))
	{
		foreach(guy in target)
		{
			if(!_lock_requirement(guy))
			{
				continue;
			}
			validtargets[validtargets.size] = guy;
		}
	}
	else
	{
		if(!_lock_requirement(target))
		{
			return;
		}
		validtargets[validtargets.size] = target;
	}
	if(isdefined(var_9bc2efcb) && var_9bc2efcb)
	{
		type = self cybercom::function_5e3d3aa();
		self orientmode("face default");
		self animscripted("ai_cybercom_anim", self.origin, self.angles, ("ai_base_rifle_" + type) + "_exposed_cybercom_activate");
		self waittillmatch(#"ai_cybercom_anim");
	}
	weapon = getweapon("gadget_system_overload");
	foreach(guy in validtargets)
	{
		if(!cybercom::targetisvalid(guy, weapon))
		{
			continue;
		}
		guy thread system_overload(self, disabletimemsec);
		wait(0.05);
	}
}

/*
	Name: system_overload
	Namespace: cybercom_gadget_system_overload
	Checksum: 0x7EDE5A05
	Offset: 0x1408
	Size: 0x716
	Parameters: 4
	Flags: Linked
*/
function system_overload(attacker, disabletimemsec, weapon = getweapon("gadget_system_overload"), checkvalid = 1)
{
	self endon(#"death");
	self notify(#"hash_f8c5dd60", weapon, attacker);
	if(isvehicle(self))
	{
		self thread _system_overload_vehicle(attacker, weapon);
		return;
	}
	if(!cybercom::function_76e3026d(self))
	{
		self kill(self.origin, (isdefined(attacker) ? attacker : undefined), undefined, weapon);
		return;
	}
	if(self cybercom::function_421746e0())
	{
		self kill(self.origin, (isdefined(attacker) ? attacker : undefined), undefined, weapon);
		return;
	}
	self.is_disabled = 1;
	if(isdefined(disabletimemsec))
	{
		disabletime = disabletimemsec;
	}
	else
	{
		if(isdefined(attacker.cybercom) && isdefined(attacker.cybercom.system_overload_lifetime))
		{
			disabletime = attacker.cybercom.system_overload_lifetime;
		}
		else
		{
			disabletime = getdvarfloat("scr_system_overload_lifetime", 6.3) * 1000;
		}
	}
	self clientfield::set("cybercom_sysoverload", 1);
	wait(randomfloatrange(0, 0.75));
	disablefor = (gettime() + disabletime) + randomint(3000);
	type = self cybercom::function_5e3d3aa();
	var_c60a5dd5 = type == "crc";
	var_fea6d69a = 0;
	var_243ca3e3 = self.pathgoalpos;
	if(self ai::has_behavior_attribute("move_mode"))
	{
		var_fea6d69a = self ai::get_behavior_attribute("move_mode") == "marching";
	}
	self thread function_53cfe88a();
	self orientmode("face default");
	self ai::set_behavior_attribute("robot_lights", 1);
	self animscripted("shutdown_anim", self.origin, self.angles, ("ai_robot_base_" + type) + "_shutdown", "normal", %generic::root, 1, 0.2);
	self thread cybercom::stopanimscriptedonnotify("damage_pain", "shutdown_anim", 1, attacker, weapon);
	self thread cybercom::stopanimscriptedonnotify("notify_melee_damage", "shutdown_anim", 1, attacker, weapon);
	self thread cybercom::stopanimscriptedonnotify("breakout_sysoverload_loop", "shutdown_anim", 0, attacker, weapon);
	self waittillmatch(#"shutdown_anim");
	waittillframeend();
	self ai::set_behavior_attribute("robot_lights", 2);
	self.ignoreall = 1;
	while(gettime() < disablefor)
	{
		if(var_c60a5dd5)
		{
			blackboard::setblackboardattribute(self, "_stance", "crouch");
		}
		self dodamage(2, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
		self waittillmatch(#"bhtn_action_terminate");
	}
	if(isalive(self) && !self isragdoll())
	{
		self ai::set_behavior_attribute("robot_lights", 0);
		self.ignoreall = 0;
		self clientfield::set("cybercom_sysoverload", 2);
		self animscripted("restart_anim", self.origin, self.angles, ("ai_robot_base_" + type) + "_shutdown_2_alert");
		self thread cybercom::stopanimscriptedonnotify("damage_pain", "restart_anim", 1, attacker, weapon);
		self thread cybercom::stopanimscriptedonnotify("notify_melee_damage", "restart_anim", 1, attacker, weapon);
		self waittillmatch(#"restart_anim");
		if(var_c60a5dd5)
		{
			blackboard::setblackboardattribute(self, "_stance", "crouch");
		}
		if(var_fea6d69a)
		{
			self ai::set_behavior_attribute("move_mode", "marching");
		}
		if(isdefined(var_243ca3e3))
		{
			self useposition(var_243ca3e3);
			self clearpath();
		}
		self.is_disabled = undefined;
	}
}

/*
	Name: function_53cfe88a
	Namespace: cybercom_gadget_system_overload
	Checksum: 0xF1BC8D8A
	Offset: 0x1B28
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function function_53cfe88a()
{
	self endon(#"death");
	wait(getdvarfloat("scr_system_overload_loop_time", 5.9));
	self notify(#"hash_355afb47");
}

