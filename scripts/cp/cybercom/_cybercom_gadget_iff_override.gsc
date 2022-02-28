// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_achievements;
#using scripts\cp\_challenges;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\archetype_robot;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;

#using_animtree("generic");

#namespace cybercom_gadget_iff_override;

/*
	Name: init
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x99EC1590
	Offset: 0x578
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_gadget_iff_override
	Checksum: 0xB8F96414
	Offset: 0x588
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(0, 64);
	level._effect["iff_takeover"] = "electric/fx_elec_sparks_burst_lg_os";
	level._effect["iff_takeover_revert"] = "explosions/fx_exp_grenade_flshbng";
	level._effect["iff_takeover_death"] = "explosions/fx_exp_grenade_flshbng";
	level.cybercom.iff_override = spawnstruct();
	level.cybercom.iff_override._is_flickering = &_is_flickering;
	level.cybercom.iff_override._on_flicker = &_on_flicker;
	level.cybercom.iff_override._on_give = &_on_give;
	level.cybercom.iff_override._on_take = &_on_take;
	level.cybercom.iff_override._on_connect = &_on_connect;
	level.cybercom.iff_override._on = &_on;
	level.cybercom.iff_override._off = &_off;
	level.cybercom.iff_override._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x1E3D09AE
	Offset: 0x768
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_iff_override
	Checksum: 0xE5290CF2
	Offset: 0x780
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x9790261F
	Offset: 0x7A0
	Size: 0x1FC
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.var_110c156a = getdvarint("scr_iff_override_count", 1);
	self.cybercom.iff_override_lifetime = getdvarint("scr_iff_override_lifetime", 60);
	self.cybercom.var_84bab148 = getdvarint("scr_iff_override_control_count", 1);
	if(self hascybercomability("cybercom_iffoverride") == 2)
	{
		self.cybercom.var_110c156a = getdvarint("scr_iff_override_upgraded_count", 2);
		self.cybercom.iff_override_lifetime = getdvarint("scr_iff_override_upgraded_lifetime", 120);
		self.cybercom.var_84bab148 = getdvarint("scr_iff_override_control_upgraded_count", 2);
	}
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self.cybercom.var_46a37937 = [];
	self.cybercom.var_73d069a7 = &function_17342509;
	self.cybercom.var_46483c8f = 63;
	self thread cybercom::function_b5f4e597(weapon);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x42B036F3
	Offset: 0x9A8
	Size: 0x72
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
	self _off(slot, weapon);
	self.cybercom.targetlockcb = undefined;
	self.cybercom.targetlockrequirementcb = undefined;
	self.cybercom.var_46483c8f = undefined;
	self.cybercom.var_73d069a7 = undefined;
}

/*
	Name: function_17342509
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x58D48724
	Offset: 0xA28
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_17342509(slot, weapon)
{
	self gadgetactivate(slot, weapon);
	_on(slot, weapon);
}

/*
	Name: _on_connect
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x99EC1590
	Offset: 0xA80
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x95DB6F7C
	Offset: 0xA90
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	self thread _activate_iff_override(slot, weapon);
	self _off(slot, weapon);
}

/*
	Name: _off
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x5DF29FB3
	Offset: 0xAF0
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
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x54ADAD9E
	Offset: 0xB38
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
	Name: function_f1ec3062
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x1E7F2914
	Offset: 0xBE8
	Size: 0xFC
	Parameters: 2
	Flags: Linked, Private
*/
function private function_f1ec3062(team, attacker)
{
	self endon(#"death");
	self waittill(#"iff_override_reverted");
	self clientfield::set("cybercom_setiffname", 4);
	self setteam(team);
	wait(1);
	self clientfield::set("cybercom_setiffname", 0);
	playfx(level._effect["iff_takeover_death"], self.origin);
	if(isdefined(attacker))
	{
		self kill(self.origin, attacker);
	}
	else
	{
		self kill();
	}
}

/*
	Name: function_2458babe
	Namespace: cybercom_gadget_iff_override
	Checksum: 0xABEA9F68
	Offset: 0xCF0
	Size: 0x1DC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_2458babe(entity)
{
	if(!isplayer(self))
	{
		return;
	}
	valid = [];
	foreach(guy in self.cybercom.var_46a37937)
	{
		if(isdefined(guy) && isalive(guy))
		{
			valid[valid.size] = guy;
		}
	}
	self.cybercom.var_46a37937 = valid;
	self.cybercom.var_46a37937[self.cybercom.var_46a37937.size] = entity;
	if(self.cybercom.var_46a37937.size > self.cybercom.var_84bab148)
	{
		var_983e95da = self.cybercom.var_46a37937[0];
		arrayremoveindex(self.cybercom.var_46a37937, 0);
		if(isdefined(var_983e95da))
		{
			var_983e95da notify(#"iff_override_reverted");
			wait(1.5);
			if(isalive(var_983e95da))
			{
				var_983e95da kill();
			}
		}
	}
}

/*
	Name: _lock_requirement
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x8926BF29
	Offset: 0xED8
	Size: 0x334
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(target cybercom::cybercom_aicheckoptout("cybercom_iffoverride"))
	{
		if(isdefined(target.rogue_controlled) && target.rogue_controlled)
		{
			self cybercom::function_29bf9dee(target, 4);
		}
		else
		{
			self cybercom::function_29bf9dee(target, 2);
		}
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
	if(isactor(target) && target.archetype == "robot" && (robotsoldierbehavior::robotiscrawler(target) || robotsoldierbehavior::robotshouldbecomecrawler(target)))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(!isactor(target) && !isvehicle(target))
	{
		return false;
	}
	if(isvehicle(target) && isdefined(target.iffowner))
	{
		self cybercom::function_29bf9dee(target, 4);
		return false;
	}
	if(isdefined(target.var_f40d252c) && target.var_f40d252c)
	{
		return false;
	}
	if(isactor(target) && target.archetype == "robot" && target ai::get_behavior_attribute("rogue_control") == "level_3")
	{
		self cybercom::function_29bf9dee(target, 4);
		return false;
	}
	return true;
}

/*
	Name: _get_valid_targets
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x180C8120
	Offset: 0x1218
	Size: 0x104
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	prospects = getaiteamarray("axis");
	valid = [];
	foreach(enemy in prospects)
	{
		if(isvehicle(enemy) || (isactor(enemy) && isdefined(enemy.archetype)))
		{
			valid[valid.size] = enemy;
		}
	}
	return valid;
}

/*
	Name: _activate_iff_override
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x66CFCFB
	Offset: 0x1328
	Size: 0x2AC
	Parameters: 2
	Flags: Linked, Private
*/
function private _activate_iff_override(slot, weapon)
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
				item.target thread iff_override(self, undefined, weapon);
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
		itemindex = getitemindexfromref("cybercom_iffoverride");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "assists", "statValue", fired);
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: _iff_leash_to_owner
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x23E31E68
	Offset: 0x15E0
	Size: 0xE8
	Parameters: 1
	Flags: Linked, Private
*/
function private _iff_leash_to_owner(owner)
{
	self endon(#"death");
	self endon(#"iff_override_reverted");
	if(isplayer(owner))
	{
		owner endon(#"disconnect");
	}
	else
	{
		owner endon(#"death");
	}
	while(isdefined(owner))
	{
		wait(randomfloatrange(1, 4));
		if(distancesquared(self.origin, owner.origin) > (self.goalradius * self.goalradius))
		{
			self setgoal(owner.origin);
		}
	}
}

/*
	Name: iff_vehiclecb
	Namespace: cybercom_gadget_iff_override
	Checksum: 0xF633AFC7
	Offset: 0x16D0
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function iff_vehiclecb(isactive)
{
	if(isactive && isdefined(self.iffowner) && isplayer(self.iffowner))
	{
		self clientfield::set("cybercom_setiffname", 2);
		self thread function_384a3bfb();
	}
	else if(!isactive && isdefined(self.iffowner))
	{
		self clientfield::set("cybercom_setiffname", 0);
		achievements::function_6903d776(self);
		self.iffowner = undefined;
		self.iff_override_cb = undefined;
		self.is_disabled = 0;
	}
}

/*
	Name: function_384a3bfb
	Namespace: cybercom_gadget_iff_override
	Checksum: 0xE2CAC318
	Offset: 0x17B8
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_384a3bfb()
{
	self endon(#"death");
	self waittill(#"iff_override_reverted");
	self clientfield::set("cybercom_setiffname", 4);
}

/*
	Name: _iff_overridevehicle
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x1746F94B
	Offset: 0x1800
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private _iff_overridevehicle(assignedowner)
{
	self endon(#"death");
	wait(randomfloatrange(0, 0.75));
	if(isplayer(assignedowner))
	{
		self.iff_override_cb = &iff_vehiclecb;
		self.iffowner = assignedowner;
	}
	assignedowner thread function_2458babe(self);
	self thread vehicle_ai::iff_override(assignedowner);
}

/*
	Name: function_2b203db0
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x14EAB942
	Offset: 0x18B0
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_2b203db0()
{
	self endon(#"death");
	self waittill(#"iff_override_revert_warn");
	self clientfield::set("cybercom_setiffname", 3);
}

/*
	Name: iff_override
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x265F25A2
	Offset: 0x18F8
	Size: 0x53C
	Parameters: 3
	Flags: Linked
*/
function iff_override(attacker, disabletimemsec, weapon = getweapon("gadget_iff_override"))
{
	self notify(#"hash_f8c5dd60", weapon, attacker);
	self clientfield::set("cybercom_setiffname", 1);
	if(isactor(self))
	{
		self ai::set_behavior_attribute("can_become_crawler", 0);
		self ai::set_behavior_attribute("can_gib", 0);
	}
	self.is_disabled = 1;
	if(isvehicle(self))
	{
		self thread function_2b203db0();
		self thread _iff_overridevehicle(attacker);
		return;
	}
	if(self cybercom::function_421746e0())
	{
		self kill(self.origin, (isdefined(attacker) ? attacker : undefined), undefined, weapon);
		return;
	}
	if(isdefined(disabletimemsec))
	{
		disabletime = int(disabletimemsec / 1000);
	}
	else
	{
		if(isdefined(attacker.cybercom) && isdefined(attacker.cybercom.iff_override_lifetime))
		{
			disabletime = attacker.cybercom.iff_override_lifetime;
		}
		else
		{
			disabletime = getdvarint("scr_iff_override_lifetime", 60);
		}
	}
	self.ignoreall = 1;
	self ai::set_behavior_attribute("robot_lights", 2);
	wait(1);
	if(!isdefined(self))
	{
		return;
	}
	entnum = self getentitynumber();
	self notify(#"cloneandremoveentity", entnum);
	level notify(#"cloneandremoveentity", entnum);
	wait(0.05);
	team = self.team;
	clone = cloneandremoveentity(self);
	if(!isdefined(clone))
	{
		return;
	}
	level notify(#"clonedentity", clone, entnum);
	if(isactor(clone))
	{
		clone ai::set_behavior_attribute("move_mode", "rusher");
	}
	attacker thread function_2458babe(clone);
	clone thread function_f1ec3062(team, attacker);
	clone thread function_2b203db0();
	clone thread _iff_override_revert_after(disabletime, attacker);
	clone.no_friendly_fire_penalty = 1;
	clone setteam(attacker.team);
	clone.remote_owner = attacker;
	clone.oldteam = team;
	if(isdefined(clone.favoriteenemy) && isdefined(clone.favoriteenemy._currentroguerobot))
	{
		clone.favoriteenemy._currentroguerobot = undefined;
	}
	clone.favoriteenemy = undefined;
	playfx(level._effect["iff_takeover"], clone.origin);
	clone thread _iff_leash_to_owner(attacker);
	clone.oldgoalradius = clone.goalradius;
	clone.goalradius = 512;
	clone clientfield::set("cybercom_setiffname", 2);
	if(isdefined(self.var_72f54197))
	{
		clone.var_72f54197 = self.var_72f54197;
	}
	if(isdefined(self.var_b0ac175a))
	{
		clone.var_b0ac175a = self.var_b0ac175a;
	}
}

/*
	Name: iff_notifymeinnsec
	Namespace: cybercom_gadget_iff_override
	Checksum: 0xB6104832
	Offset: 0x1E40
	Size: 0x2E
	Parameters: 2
	Flags: None
*/
function iff_notifymeinnsec(time, note)
{
	self endon(#"death");
	wait(time);
	self notify(note);
}

/*
	Name: _iff_override_revert_after
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x8BC27BC3
	Offset: 0x1E78
	Size: 0x8A
	Parameters: 2
	Flags: Linked, Private
*/
function private _iff_override_revert_after(timesec, attacker)
{
	self endon(#"death");
	wait(timesec - 6);
	self notify(#"iff_override_revert_warn");
	wait(6);
	self clientfield::set("cybercom_setiffname", 4);
	wait(2);
	self setteam(self.oldteam);
	self notify(#"iff_override_reverted");
}

/*
	Name: ai_activateiffoverride
	Namespace: cybercom_gadget_iff_override
	Checksum: 0x75C4995F
	Offset: 0x1F10
	Size: 0x2BA
	Parameters: 2
	Flags: Linked
*/
function ai_activateiffoverride(target, var_9bc2efcb = 1)
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
	weapon = getweapon("gadget_iff_override");
	foreach(guy in validtargets)
	{
		if(!cybercom::targetisvalid(guy, weapon))
		{
			continue;
		}
		guy thread iff_override(self, undefined, undefined);
		wait(0.05);
	}
}

