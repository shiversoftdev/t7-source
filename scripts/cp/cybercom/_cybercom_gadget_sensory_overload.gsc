// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace cybercom_gadget_sensory_overload;

/*
	Name: init
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x84CFFECB
	Offset: 0x690
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("actor", "sensory_overload", 1, 2, "int");
}

/*
	Name: main
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x95193C8B
	Offset: 0x6D0
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(2, 1);
	level._effect["sensory_disable_human"] = "electric/fx_ability_elec_sensory_ol_human";
	level._effect["sensory_disable_human_riotshield"] = "electric/fx_ability_elec_sensory_ol_human";
	level._effect["sensory_disable_warlord"] = "electric/fx_ability_elec_sensory_ol_human";
	level.cybercom.sensory_overload = spawnstruct();
	level.cybercom.sensory_overload._is_flickering = &_is_flickering;
	level.cybercom.sensory_overload._on_flicker = &_on_flicker;
	level.cybercom.sensory_overload._on_give = &_on_give;
	level.cybercom.sensory_overload._on_take = &_on_take;
	level.cybercom.sensory_overload._on_connect = &_on_connect;
	level.cybercom.sensory_overload._on = &_on;
	level.cybercom.sensory_overload._off = &_off;
	level.cybercom.sensory_overload._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x86062341
	Offset: 0x8B0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0xB2B85BC4
	Offset: 0x8C8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x105ACE88
	Offset: 0x8E8
	Size: 0x1D4
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.var_110c156a = getdvarint("scr_sensory_overload_count", 3);
	self.cybercom.var_bf39536d = getdvarint("scr_sensory_overload_loops", 2);
	if(self hascybercomability("cybercom_sensoryoverload") == 2)
	{
		self.cybercom.var_110c156a = getdvarint("scr_sensory_overload_upgraded_count", 5);
		self.cybercom.var_bf39536d = getdvarint("scr_sensory_overload_upgraded_loops", 2);
	}
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self thread cybercom::function_b5f4e597(weapon);
	self cybercom::function_8257bcb3("base_rifle_stn", 8);
	self cybercom::function_8257bcb3("base_rifle_crc", 2);
	self cybercom::function_8257bcb3("fem_rifle_stn", 8);
	self cybercom::function_8257bcb3("fem_rifle_crc", 2);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0xD078BFF6
	Offset: 0xAC8
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
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x99EC1590
	Offset: 0xB28
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0xF637F1FA
	Offset: 0xB38
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	self thread _activate_sensory_overload(slot, weapon);
	self _off(slot, weapon);
}

/*
	Name: _off
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0xE0338895
	Offset: 0xB98
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
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x8B67A3BD
	Offset: 0xBE0
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
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x35E46BCC
	Offset: 0xC90
	Size: 0x208
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(target cybercom::cybercom_aicheckoptout("cybercom_sensoryoverload"))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(isdefined(target.is_disabled) && target.is_disabled)
	{
		self cybercom::function_29bf9dee(target, 6);
		return false;
	}
	if(isvehicle(target) || !isdefined(target.archetype))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(target.archetype != "human" && target.archetype != "human_riotshield" && target.archetype != "warlord")
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
	return true;
}

/*
	Name: _get_valid_targets
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x7053633B
	Offset: 0xEA0
	Size: 0x52
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	return arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
}

/*
	Name: _activate_sensory_overload
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x3FE204F4
	Offset: 0xF00
	Size: 0x2A4
	Parameters: 2
	Flags: Linked, Private
*/
function private _activate_sensory_overload(slot, weapon)
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
				self thread challenges::function_96ed590f("cybercom_uses_chaos");
				item.target thread sensory_overload(self);
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
		itemindex = getitemindexfromref("cybercom_sensoryoverload");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "assists", "statValue", fired);
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: ai_activatesensoryoverload
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0xAD4D11E5
	Offset: 0x11B0
	Size: 0x2E2
	Parameters: 2
	Flags: Linked
*/
function ai_activatesensoryoverload(target, var_9bc2efcb = 1)
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
		self animscripted("ai_cybercom_anim", self.origin, self.angles, ("ai_base_rifle_" + type) + "_exposed_cybercom_activate", "normal", %generic::root, 1, 0.3);
		self waittillmatch(#"ai_cybercom_anim");
	}
	weapon = getweapon("gadget_sensory_overload");
	foreach(guy in validtargets)
	{
		if(!cybercom::targetisvalid(guy, weapon))
		{
			continue;
		}
		guy thread sensory_overload(self);
		wait(0.05);
	}
}

/*
	Name: sensory_overload
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x2FCE7356
	Offset: 0x14A0
	Size: 0x7B8
	Parameters: 2
	Flags: Linked
*/
function sensory_overload(attacker, var_7d4fd98c)
{
	self endon(#"death");
	weapon = getweapon("gadget_sensory_overload");
	self notify(#"hash_f8c5dd60", weapon, attacker);
	if(isdefined(attacker.cybercom) && isdefined(attacker.cybercom.var_bf39536d))
	{
		loops = attacker.cybercom.var_bf39536d;
	}
	else
	{
		loops = 1;
	}
	wait(randomfloatrange(0, 0.75));
	if(!attacker cybercom::targetisvalid(self, weapon))
	{
		return;
	}
	if(self cybercom::function_421746e0())
	{
		self kill(self.origin, (isdefined(attacker) ? attacker : undefined), undefined, weapon);
		return;
	}
	self orientmode("face default");
	self.is_disabled = 1;
	self.ignoreall = 1;
	if(isdefined(var_7d4fd98c))
	{
		if(var_7d4fd98c == "cybercom_smokescreen")
		{
			self.var_d90f9ddb = 1;
		}
	}
	if(isplayer(attacker) && attacker hascybercomability("cybercom_sensoryoverload") == 2)
	{
		self playsound("gdt_sensory_feedback_start");
		self playloopsound("gdt_sensory_feedback_lp_upg", 0.5);
		self clientfield::set("sensory_overload", 2);
	}
	else
	{
		self playsound("gdt_sensory_feedback_start");
		self playloopsound("gdt_sensory_feedback_lp", 0.5);
		self clientfield::set("sensory_overload", 1);
	}
	self notify(#"bhtn_action_notify", "reactSensory");
	if(self.archetype == "warlord")
	{
		self dodamage(2, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
		self waittillmatch(#"bhtn_action_terminate");
		self clientfield::set("sensory_overload", 0);
	}
	else
	{
		if(self.archetype == "human_riotshield")
		{
			while(loops)
			{
				self dodamage(2, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
				self waittillmatch(#"bhtn_action_terminate");
				loops--;
			}
			self clientfield::set("sensory_overload", 0);
		}
		else
		{
			/#
				assert(self.archetype == "");
			#/
			base = "base_rifle";
			if(isdefined(self.voiceprefix) && getsubstr(self.voiceprefix, 7) == "f")
			{
				base = "fem_rifle";
			}
			type = self cybercom::function_5e3d3aa();
			variant = attacker cybercom::getanimationvariant((base + "_") + type);
			self animscripted("intro_anim", self.origin, self.angles, (((("ai_" + base) + "_") + type) + "_exposed_sens_overload_react_intro") + variant, "normal", %generic::root, 1, 0.3);
			self thread cybercom::stopanimscriptedonnotify("damage_pain", "intro_anim", 1, attacker, weapon);
			self thread cybercom::stopanimscriptedonnotify("notify_melee_damage", "intro_anim", 1, attacker, weapon);
			self waittillmatch(#"intro_anim");
			function_58831b5a(loops, attacker, weapon, variant, base, type);
			if(isalive(self) && !self isragdoll())
			{
				self clientfield::set("sensory_overload", 0);
				self animscripted("restart_anim", self.origin, self.angles, (((("ai_" + base) + "_") + type) + "_exposed_sens_overload_react_outro") + variant, "normal", %generic::root, 1, 0.3);
				self thread cybercom::stopanimscriptedonnotify("damage_pain", "restart_anim", 1, attacker, weapon);
				self thread cybercom::stopanimscriptedonnotify("notify_melee_damage", "restart_anim", 1, attacker, weapon);
				self waittillmatch(#"restart_anim");
			}
		}
	}
	self stoploopsound(0.75);
	self.is_disabled = undefined;
	self.ignoreall = 0;
	if(isdefined(var_7d4fd98c))
	{
		if(var_7d4fd98c == "cybercom_smokescreen")
		{
			self.var_d90f9ddb = 0;
		}
	}
}

/*
	Name: function_58831b5a
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0xBE413C76
	Offset: 0x1C60
	Size: 0x8E
	Parameters: 6
	Flags: Linked
*/
function function_58831b5a(loops, attacker, weapon, variant, base, type)
{
	self endon(#"hash_8817762c");
	self thread function_53cfe88a();
	while(loops)
	{
		self function_e01b8059(attacker, weapon, variant, base, type);
		loops--;
	}
}

/*
	Name: function_e01b8059
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0xF79030D3
	Offset: 0x1CF8
	Size: 0x15A
	Parameters: 5
	Flags: Linked
*/
function function_e01b8059(attacker, weapon, variant, base, type)
{
	self endon(#"death");
	self animscripted("sens_loop_anim", self.origin, self.angles, (((("ai_" + base) + "_") + type) + "_exposed_sens_overload_react_loop") + variant, "normal", %generic::body, 1, 0.2);
	self thread cybercom::stopanimscriptedonnotify("damage_pain", "sens_loop_anim", 1, attacker, weapon);
	self thread cybercom::stopanimscriptedonnotify("breakout_overload_loop", "sens_loop_anim", 0, attacker, weapon);
	self thread cybercom::stopanimscriptedonnotify("notify_melee_damage", "sens_loop_anim", 1, attacker, weapon);
	self waittillmatch(#"hash_3b87dc07");
}

/*
	Name: function_53cfe88a
	Namespace: cybercom_gadget_sensory_overload
	Checksum: 0x6F8DE54
	Offset: 0x1E60
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function function_53cfe88a()
{
	self endon(#"death");
	wait(getdvarfloat("scr_sensory_overload_loop_time", 4.7));
	self notify(#"hash_8817762c");
}

