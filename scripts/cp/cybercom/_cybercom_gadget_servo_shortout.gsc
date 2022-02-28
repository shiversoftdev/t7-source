// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_amws;

#using_animtree("generic");

#namespace cybercom_gadget_servo_shortout;

/*
	Name: init
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0x99EC1590
	Offset: 0x570
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0x9F4B1A34
	Offset: 0x580
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(0, 2);
	level.cybercom.servo_shortout = spawnstruct();
	level.cybercom.servo_shortout._is_flickering = &_is_flickering;
	level.cybercom.servo_shortout._on_flicker = &_on_flicker;
	level.cybercom.servo_shortout._on_give = &_on_give;
	level.cybercom.servo_shortout._on_take = &_on_take;
	level.cybercom.servo_shortout._on_connect = &_on_connect;
	level.cybercom.servo_shortout._on = &_on;
	level.cybercom.servo_shortout._off = &_off;
	level.cybercom.servo_shortout._is_primed = &_is_primed;
	level.cybercom.servo_shortout.gibcounter = 0;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xCE370C6E
	Offset: 0x720
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0x10C8C282
	Offset: 0x738
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0x976B2FE4
	Offset: 0x758
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.var_110c156a = getdvarint("scr_servo_shortout_count", 2);
	if(self hascybercomability("cybercom_servoshortout") == 2)
	{
		self.cybercom.var_110c156a = getdvarint("scr_servo_shortout_upgraded_count", 3);
	}
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self thread cybercom::function_b5f4e597(weapon);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xADF1C12
	Offset: 0x858
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
	self _off(slot, weapon);
	self.cybercom.targetlockcb = undefined;
	self.cybercom.targetlockrequirementcb = undefined;
}

/*
	Name: _on_connect
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0x99EC1590
	Offset: 0x8B8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xB9FDDF5
	Offset: 0x8C8
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	self thread _activate_servo_shortout(slot, weapon);
	self _off(slot, weapon);
}

/*
	Name: _off
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xFC70E955
	Offset: 0x928
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
	self thread cybercom::weaponendlockwatcher(weapon);
	self.cybercom.is_primed = undefined;
}

/*
	Name: _is_primed
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xC44C6A97
	Offset: 0x970
	Size: 0xA8
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
		self thread cybercom::weaponlockwatcher(slot, weapon, self.cybercom.var_110c156a);
		self.cybercom.is_primed = 1;
	}
}

/*
	Name: _lock_requirement
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xDDB3E14D
	Offset: 0xA20
	Size: 0x268
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(target cybercom::cybercom_aicheckoptout("cybercom_servoshortout"))
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
	if(!isdefined(target.archetype))
	{
		self cybercom::function_29bf9dee(target, 2);
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
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xF135BFAD
	Offset: 0xC90
	Size: 0x52
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	return arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
}

/*
	Name: _activate_servo_shortout
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xBE0267F1
	Offset: 0xCF0
	Size: 0x394
	Parameters: 2
	Flags: Linked, Private
*/
function private _activate_servo_shortout(slot, weapon)
{
	var_98c55a0e = 0;
	upgraded = self hascybercomability("cybercom_servoshortout") == 2;
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
				if(!var_98c55a0e && randomint(100) < (upgraded ? getdvarint("scr_servo_killchance_upgraded", 30) : getdvarint("scr_servo_killchance", 15)))
				{
					item.target thread servo_shortout(self, undefined, upgraded, 1);
					var_98c55a0e = 1;
				}
				else
				{
					item.target thread servo_shortout(self, undefined, upgraded, 0);
				}
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
		itemindex = getitemindexfromref("cybercom_servoshortout");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "assists", "statValue", fired);
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: _update_gib_position
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xB1EE8C00
	Offset: 0x1090
	Size: 0x38
	Parameters: 0
	Flags: Private
*/
function private _update_gib_position()
{
	level.cybercom.servo_shortout.gibcounter++;
	return level.cybercom.servo_shortout.gibcounter % 3;
}

/*
	Name: servo_shortoutvehicle
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xA3567179
	Offset: 0x10D0
	Size: 0x274
	Parameters: 3
	Flags: Linked
*/
function servo_shortoutvehicle(attacker, upgraded, weapon)
{
	self endon(#"death");
	self clientfield::set("cybercom_shortout", (upgraded ? 2 : 1));
	util::wait_network_frame();
	wait(0.5);
	if(issubstr(self.vehicletype, "wasp"))
	{
		if(isalive(self))
		{
			self.death_type = "gibbed";
			self kill(self.origin, (isdefined(attacker) ? attacker : undefined), undefined, weapon);
		}
	}
	else
	{
		if(issubstr(self.vehicletype, "raps"))
		{
			self.servershortout = 1;
			self thread function_a61788ff();
			self dodamage(1, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_ELECTROCUTED");
		}
		else
		{
			if(issubstr(self.vehicletype, "amws"))
			{
				if(isalive(self))
				{
					self amws::gib(attacker);
				}
			}
			else
			{
				dmg = int(self.healthdefault * 0.1);
				self dodamage(dmg, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_GRENADE_SPLASH", 0, getweapon("emp_grenade"), -1, 1);
			}
		}
	}
}

/*
	Name: function_a61788ff
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0x9ECF3DF
	Offset: 0x1350
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_a61788ff()
{
	self stopsounds();
}

/*
	Name: servo_shortout
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0x34E94970
	Offset: 0x1378
	Size: 0x368
	Parameters: 5
	Flags: Linked
*/
function servo_shortout(attacker, weapon = getweapon("gadget_servo_shortout"), upgraded, var_66a2f0cf, damage = 2)
{
	self endon(#"death");
	self notify(#"hash_f8c5dd60", weapon, attacker);
	if(isvehicle(self))
	{
		self thread servo_shortoutvehicle(attacker, upgraded, weapon);
		return;
	}
	/#
		assert(self.archetype == "");
	#/
	self clientfield::set("cybercom_shortout", 1);
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
	wait(randomfloatrange(0, 0.35));
	self.is_disabled = 1;
	self dodamage(damage, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
	time = randomfloatrange(0.8, 2.1);
	for(i = 0; i < 2; i++)
	{
		destructserverutils::destructnumberrandompieces(self, randomintrange(1, 3));
		wait(time / 3);
	}
	if(isalive(self))
	{
		if(isdefined(var_66a2f0cf) && var_66a2f0cf)
		{
			self kill(self.origin, (isdefined(attacker) ? attacker : undefined), undefined, weapon);
		}
		else
		{
			self clientfield::set("cybercom_shortout", 2);
			self ai::set_behavior_attribute("force_crawler", "gib_legs");
			self.is_disabled = 0;
		}
	}
}

/*
	Name: ai_activateservoshortout
	Namespace: cybercom_gadget_servo_shortout
	Checksum: 0xF5EF8E7A
	Offset: 0x16E8
	Size: 0x2BA
	Parameters: 2
	Flags: Linked
*/
function ai_activateservoshortout(target, var_9bc2efcb = 1)
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
	weapon = getweapon("gadget_servo_shortout");
	foreach(guy in validtargets)
	{
		if(!cybercom::targetisvalid(guy, weapon))
		{
			continue;
		}
		guy thread servo_shortout(self);
		wait(0.05);
	}
}

