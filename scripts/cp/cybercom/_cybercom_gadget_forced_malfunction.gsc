// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace cybercom_gadget_forced_malfunction;

/*
	Name: init
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0xB36B509F
	Offset: 0x528
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("actor", "forced_malfunction", 1, 1, "int");
}

/*
	Name: main
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0xD0EC5E2B
	Offset: 0x568
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(1, 2);
	level.cybercom.forced_malfunction = spawnstruct();
	level.cybercom.forced_malfunction._is_flickering = &_is_flickering;
	level.cybercom.forced_malfunction._on_flicker = &_on_flicker;
	level.cybercom.forced_malfunction._on_give = &_on_give;
	level.cybercom.forced_malfunction._on_take = &_on_take;
	level.cybercom.forced_malfunction._on_connect = &_on_connect;
	level.cybercom.forced_malfunction._on = &_on;
	level.cybercom.forced_malfunction._off = &_off;
	level.cybercom.forced_malfunction._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x15FD0BC9
	Offset: 0x6F0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0xA557BC78
	Offset: 0x708
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x4053B4C
	Offset: 0x728
	Size: 0x154
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.var_110c156a = getdvarint("scr_forced_malfunction_count", 2);
	if(self hascybercomability("cybercom_forcedmalfunction") == 2)
	{
		self.cybercom.var_110c156a = getdvarint("scr_forced_malfunction_upgraded_count", 4);
	}
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self thread cybercom::function_b5f4e597(weapon);
	self cybercom::function_8257bcb3("base_rifle", 5);
	self cybercom::function_8257bcb3("fem_rifle", 3);
	self cybercom::function_8257bcb3("riotshield", 2);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x56EBE727
	Offset: 0x888
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
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x99EC1590
	Offset: 0x8E8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0xC5B2AE50
	Offset: 0x8F8
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	self thread _activate_forced_malfunction(slot, weapon);
	self _off(slot, weapon);
}

/*
	Name: _off
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x26FA9531
	Offset: 0x958
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
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0xC0A06D7E
	Offset: 0x9A0
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
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0xEBA66962
	Offset: 0xA50
	Size: 0x2BC
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(target cybercom::cybercom_aicheckoptout("cybercom_forcedmalfunction"))
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
	if(isvehicle(target))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(isactor(target) && isdefined(target.archetype) && (target.archetype == "zombie" || target.archetype == "direwolf"))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(isactor(target) && target cybercom::function_78525729() != "stand" && target cybercom::function_78525729() != "crouch")
	{
		return false;
	}
	if(isactor(target) && !target isonground() && !target cybercom::function_421746e0())
	{
		return false;
	}
	if(isactor(target) && isdefined(target.weapon) && target.weapon.name == "none")
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	return true;
}

/*
	Name: _get_valid_targets
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x4EC68EAA
	Offset: 0xD18
	Size: 0x52
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	return arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
}

/*
	Name: _activate_forced_malfunction
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0xB9A64992
	Offset: 0xD78
	Size: 0x2A4
	Parameters: 2
	Flags: Linked, Private
*/
function private _activate_forced_malfunction(slot, weapon)
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
				self thread challenges::function_96ed590f("cybercom_uses_martial");
				item.target thread _force_malfunction(self, undefined);
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
	if(fired && isplayer(self))
	{
		itemindex = getitemindexfromref("cybercom_forcedmalfunction");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "assists", "statValue", fired);
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
	cybercom::function_adc40f11(weapon, fired);
}

/*
	Name: function_586fec95
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x34930FAB
	Offset: 0x1028
	Size: 0xE4
	Parameters: 3
	Flags: Linked, Private
*/
function private function_586fec95(attacker, disablefor, weapon)
{
	self endon(#"death");
	self clientfield::set("forced_malfunction", 1);
	self.is_disabled = 1;
	self dodamage(5, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
	self waittillmatch(#"bhtn_action_terminate");
	self.is_disabled = 0;
	self clientfield::set("forced_malfunction", 0);
}

/*
	Name: function_609fcb0a
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x6ECF571A
	Offset: 0x1118
	Size: 0x1D0
	Parameters: 3
	Flags: Linked, Private
*/
function private function_609fcb0a(attacker, disablefor, weapon)
{
	self endon(#"death");
	if(!cybercom::function_76e3026d(self))
	{
		self kill(self.origin, (isdefined(attacker) ? attacker : undefined));
		return;
	}
	self clientfield::set("forced_malfunction", 1);
	self.is_disabled = 1;
	miss = 100;
	while(isalive(self) && gettime() < disablefor)
	{
		if((getdvarint("scr_malfunction_rate_of_failure", 25) + miss) > randomint(100))
		{
			miss = 0;
			self dodamage(5, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
			self waittillmatch(#"bhtn_action_terminate");
		}
		else
		{
			miss = miss + 10;
			wait(randomintrange(1, 3));
		}
	}
	self clientfield::set("forced_malfunction", 0);
	self.is_disabled = 0;
}

/*
	Name: _force_malfunction
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0xFA12EE08
	Offset: 0x12F0
	Size: 0x55C
	Parameters: 2
	Flags: Linked, Private
*/
function private _force_malfunction(attacker, disabletimemsec)
{
	self endon(#"death");
	weapon = getweapon("gadget_forced_malfunction");
	self notify(#"hash_f8c5dd60", weapon, attacker);
	if(isdefined(disabletimemsec))
	{
		disabletime = disabletimemsec;
	}
	else
	{
		disabletime = getdvarint("scr_malfunction_duration", 15) * 1000;
	}
	if(!attacker cybercom::targetisvalid(self, weapon))
	{
		return;
	}
	if(self cybercom::function_421746e0())
	{
		self kill(self.origin, (isdefined(attacker) ? attacker : undefined), undefined, weapon);
		return;
	}
	disablefor = (gettime() + disabletime) + randomint(4000);
	if(self.archetype == "robot")
	{
		self thread function_609fcb0a(attacker, disablefor, weapon);
		return;
	}
	if(self.archetype == "warlord")
	{
		self thread function_586fec95(attacker, disablefor, weapon);
		return;
	}
	/#
		assert(self.archetype == "" || self.archetype == "");
	#/
	type = self cybercom::function_5e3d3aa();
	self clientfield::set("forced_malfunction", 1);
	goalpos = self.goalpos;
	goalradius = self.goalradius;
	self.goalradius = 32;
	if(self isactorshooting())
	{
		base = "base_rifle";
		if(isdefined(self.voiceprefix) && getsubstr(self.voiceprefix, 7) == "f")
		{
			base = "fem_rifle";
		}
		else if(self.archetype == "human_riotshield")
		{
			base = "riotshield";
		}
		type = self cybercom::function_5e3d3aa();
		variant = attacker cybercom::getanimationvariant(base);
		self animscripted("malfunction_intro_anim", self.origin, self.angles, (((("ai_" + base) + "_") + type) + "_exposed_rifle_malfunction") + variant);
		self thread cybercom::stopanimscriptedonnotify("damage_pain", "malfunction_intro_anim", 1, attacker, weapon);
		self thread cybercom::stopanimscriptedonnotify("notify_melee_damage", "malfunction_intro_anim", 1, attacker, weapon);
		self waittillmatch(#"malfunction_intro_anim");
	}
	var_ac712236 = 0;
	while(isalive(self) && gettime() < disablefor)
	{
		if(gettime() > var_ac712236)
		{
			var_ac712236 = gettime() + (randomfloatrange(getdvarfloat("scr_malfunction_duration_min_wait", 2), getdvarfloat("scr_malfunction_duration_max_wait", 3.25)) * 1000);
			if(getdvarint("scr_malfunction_rate_of_failure", 90) > randomint(100))
			{
				self.malfunctionreaction = 1;
			}
			else
			{
				self.malfunctionreaction = 0;
			}
		}
		wait(0.2);
	}
	self clientfield::set("forced_malfunction", 0);
	self.malfunctionreaction = undefined;
	self.melee_charge_rangesq = undefined;
	self.goalradius = goalradius;
	self setgoal(goalpos, 1);
}

/*
	Name: ai_activateforcedmalfuncton
	Namespace: cybercom_gadget_forced_malfunction
	Checksum: 0x948CF286
	Offset: 0x1858
	Size: 0x2A2
	Parameters: 2
	Flags: Linked
*/
function ai_activateforcedmalfuncton(target, var_9bc2efcb = 1)
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
		self animscripted("ai_cybercom_anim", self.origin, self.angles, ("ai_base_rifle_" + type) + "_exposed_cybercom_activate");
		self waittillmatch(#"ai_cybercom_anim");
	}
	weapon = getweapon("gadget_forced_malfunction");
	foreach(guy in validtargets)
	{
		if(!cybercom::targetisvalid(guy, weapon))
		{
			continue;
		}
		guy thread _force_malfunction(self);
		wait(0.05);
	}
}

