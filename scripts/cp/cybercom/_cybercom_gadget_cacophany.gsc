// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
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

#namespace namespace_6dcc04c7;

/*
	Name: init
	Namespace: namespace_6dcc04c7
	Checksum: 0x99EC1590
	Offset: 0x350
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: namespace_6dcc04c7
	Checksum: 0x92F8397B
	Offset: 0x360
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(2, 16);
	level.cybercom.cacophany = spawnstruct();
	level.cybercom.cacophany._is_flickering = &_is_flickering;
	level.cybercom.cacophany._on_flicker = &_on_flicker;
	level.cybercom.cacophany._on_give = &_on_give;
	level.cybercom.cacophany._on_take = &_on_take;
	level.cybercom.cacophany._on_connect = &_on_connect;
	level.cybercom.cacophany._on = &_on;
	level.cybercom.cacophany._off = &_off;
	level.cybercom.cacophany._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: namespace_6dcc04c7
	Checksum: 0x245BFE36
	Offset: 0x4E8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: namespace_6dcc04c7
	Checksum: 0x57427223
	Offset: 0x500
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: namespace_6dcc04c7
	Checksum: 0x220D8889
	Offset: 0x520
	Size: 0x1B4
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.var_110c156a = getdvarint("scr_cacophany_count", 4);
	self.cybercom.var_f72b478f = getdvarfloat("scr_cacophany_fov", 0.95);
	self.cybercom.var_23d4a73a = getdvarfloat("scr_cacophany_lock_radius", 330);
	if(self hascybercomability("cybercom_cacophany") == 2)
	{
		self.cybercom.var_110c156a = getdvarint("scr_cacophany_upgraded_count", 5);
		self.cybercom.var_f72b478f = getdvarfloat("scr_cacophany_upgraded_fov", 0.5);
		self.cybercom.var_23d4a73a = getdvarfloat("scr_cacophany_lock_radius", 330);
	}
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self thread cybercom::function_b5f4e597(weapon);
}

/*
	Name: _on_take
	Namespace: namespace_6dcc04c7
	Checksum: 0x806E6AA3
	Offset: 0x6E0
	Size: 0x72
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
	self _off(slot, weapon);
	self.cybercom.targetlockcb = undefined;
	self.cybercom.targetlockrequirementcb = undefined;
	self.cybercom.var_f72b478f = undefined;
	self.cybercom.var_23d4a73a = undefined;
}

/*
	Name: _on_connect
	Namespace: namespace_6dcc04c7
	Checksum: 0x99EC1590
	Offset: 0x760
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: namespace_6dcc04c7
	Checksum: 0xA276F931
	Offset: 0x770
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	self thread function_7f3f3bde(slot, weapon);
	self _off(slot, weapon);
}

/*
	Name: _off
	Namespace: namespace_6dcc04c7
	Checksum: 0xE8D05293
	Offset: 0x7D0
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
	Namespace: namespace_6dcc04c7
	Checksum: 0x264E9FC6
	Offset: 0x818
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
	Namespace: namespace_6dcc04c7
	Checksum: 0x6C8227D3
	Offset: 0x8C8
	Size: 0xDC
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(target cybercom::cybercom_aicheckoptout("cybercom_cacophany"))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(isdefined(target.destroyingweapon))
	{
		return false;
	}
	if(isdefined(target.var_37915be0) && target.var_37915be0)
	{
		return false;
	}
	if(isdefined(target.is_disabled) && target.is_disabled)
	{
		self cybercom::function_29bf9dee(target, 6);
		return false;
	}
	return true;
}

/*
	Name: _get_valid_targets
	Namespace: namespace_6dcc04c7
	Checksum: 0x56CAD3C9
	Offset: 0x9B0
	Size: 0x2A
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	return getentarray("destructible", "targetname");
}

/*
	Name: function_7f3f3bde
	Namespace: namespace_6dcc04c7
	Checksum: 0xC25AC954
	Offset: 0x9E8
	Size: 0x28C
	Parameters: 2
	Flags: Linked, Private
*/
function private function_7f3f3bde(slot, weapon)
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
				item.target thread function_41e98fcc(self, fired);
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
		itemindex = getitemindexfromref("cybercom_cacophany");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "assists", "statValue", fired);
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: function_41e98fcc
	Namespace: namespace_6dcc04c7
	Checksum: 0x3E1FABF9
	Offset: 0xC80
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function function_41e98fcc(attacker, offset)
{
	if(offset == 0)
	{
		wait(0.1);
	}
	else
	{
		var_f5aa368a = 0.15 + (randomfloatrange(0.1, 0.25) * offset);
		wait(var_f5aa368a);
	}
	self dodamage(self.health + 100, self.origin, attacker, attacker);
	self.var_37915be0 = 1;
}

