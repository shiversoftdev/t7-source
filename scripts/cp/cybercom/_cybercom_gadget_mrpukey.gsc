// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
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

#using_animtree("generic");

#namespace namespace_e44205a2;

/*
	Name: init
	Namespace: namespace_e44205a2
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
	Namespace: namespace_e44205a2
	Checksum: 0x6AF5EABC
	Offset: 0x588
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(2, 64);
	level._effect["puke_reaction"] = "water/fx_liquid_vomit";
	level.cybercom.mrpukey = spawnstruct();
	level.cybercom.mrpukey._is_flickering = &_is_flickering;
	level.cybercom.mrpukey._on_flicker = &_on_flicker;
	level.cybercom.mrpukey._on_give = &_on_give;
	level.cybercom.mrpukey._on_take = &_on_take;
	level.cybercom.mrpukey._on_connect = &_on_connect;
	level.cybercom.mrpukey._on = &_on;
	level.cybercom.mrpukey._off = &_off;
	level.cybercom.mrpukey._is_primed = &_is_primed;
	level.cybercom.mrpukey.var_106f11dd = array("c_54i_cqb_head1", "c_nrc_cqb_head", "c_nrc_cqb_f_head", "c_54i_supp_head1", "c_54i_supp_head1", "c_nrc_sniper_head", "c_nrc_suppressor_head");
}

/*
	Name: _is_flickering
	Namespace: namespace_e44205a2
	Checksum: 0xDE61FF3E
	Offset: 0x790
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: namespace_e44205a2
	Checksum: 0xF7208179
	Offset: 0x7A8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: namespace_e44205a2
	Checksum: 0xF4C16B13
	Offset: 0x7C8
	Size: 0x1B4
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.var_110c156a = getdvarint("scr_mrpukey_target_count", 4);
	self.cybercom.var_cf33c5a4 = getdvarfloat("scr_pukey_fov", 0.968);
	if(self hascybercomability("cybercom_mrpukey") == 2)
	{
		self.cybercom.var_f72b478f = getdvarfloat("scr_pukey_upgraded_fov", 0.92);
		self.cybercom.var_110c156a = getdvarint("scr_mrpukey_target_count_upgraded", 5);
	}
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self thread cybercom::function_b5f4e597(weapon);
	self cybercom::function_8257bcb3("base_rifle", 5);
	self cybercom::function_8257bcb3("fem_rifle", 5);
	self cybercom::function_8257bcb3("riotshield", 2);
}

/*
	Name: _on_take
	Namespace: namespace_e44205a2
	Checksum: 0x14D873F9
	Offset: 0x988
	Size: 0x62
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
	self _off(slot, weapon);
	self.cybercom.targetlockcb = undefined;
	self.cybercom.targetlockrequirementcb = undefined;
	self.cybercom.var_f72b478f = undefined;
}

/*
	Name: _on_connect
	Namespace: namespace_e44205a2
	Checksum: 0x99EC1590
	Offset: 0x9F8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: namespace_e44205a2
	Checksum: 0x606EEADC
	Offset: 0xA08
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	self thread function_2de61c3f(slot, weapon);
	self _off(slot, weapon);
}

/*
	Name: _off
	Namespace: namespace_e44205a2
	Checksum: 0x7BF646E9
	Offset: 0xA68
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
	Namespace: namespace_e44205a2
	Checksum: 0x6A6D4CBC
	Offset: 0xAB0
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
	Namespace: namespace_e44205a2
	Checksum: 0x13C08C9B
	Offset: 0xB60
	Size: 0x200
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(target cybercom::cybercom_aicheckoptout("cybercom_mrpukey"))
	{
		self cybercom::function_29bf9dee(target, 2);
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
	if(isvehicle(target) || !isdefined(target.archetype))
	{
		self cybercom::function_29bf9dee(target, 2);
		return false;
	}
	if(isactor(target) && target.archetype != "human" && target.archetype != "human_riotshield")
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
	Namespace: namespace_e44205a2
	Checksum: 0xA7FA5BE3
	Offset: 0xD68
	Size: 0x52
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	return arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
}

/*
	Name: function_2de61c3f
	Namespace: namespace_e44205a2
	Checksum: 0xD3560DCD
	Offset: 0xDC8
	Size: 0x2E4
	Parameters: 2
	Flags: Linked, Private
*/
function private function_2de61c3f(slot, weapon)
{
	upgraded = self hascybercomability("cybercom_mrpukey") == 2;
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
				item.target thread function_25411db1(upgraded, 0, self, weapon);
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
		itemindex = getitemindexfromref("cybercom_mrpukey");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "kills", "statValue", fired);
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: function_25411db1
	Namespace: namespace_e44205a2
	Checksum: 0xBDB74FCD
	Offset: 0x10B8
	Size: 0x1EC
	Parameters: 4
	Flags: Linked, Private
*/
function private function_25411db1(upgraded = 0, secondary = 0, attacker, weapon)
{
	self notify(#"hash_f8c5dd60", weapon, attacker);
	weapon = getweapon("gadget_mrpukey");
	self.ignoreall = 1;
	self.is_disabled = 1;
	self dodamage(self.health + 666, self.origin, (isdefined(attacker) ? attacker : undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
	if(self function_ceb2ee11())
	{
		self waittill(#"puke");
		playfxontag(level._effect["puke_reaction"], self, "j_neck");
		if(isdefined(self.voiceprefix) && isdefined(self.bcvoicenumber))
		{
			self thread battlechatter::do_sound((self.voiceprefix + self.bcvoicenumber) + "_puke", 1);
		}
	}
	else
	{
		wait(0.2);
		if(isdefined(self))
		{
			if(isdefined(self.voiceprefix) && isdefined(self.bcvoicenumber))
			{
				self thread battlechatter::do_sound((self.voiceprefix + self.bcvoicenumber) + "_exert_sonic", 1);
			}
		}
	}
}

/*
	Name: function_ceb2ee11
	Namespace: namespace_e44205a2
	Checksum: 0xADA038DB
	Offset: 0x12B0
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function function_ceb2ee11()
{
	attachsize = self getattachsize();
	for(i = 0; i < attachsize; i++)
	{
		model_name = self getattachmodelname(i);
		if(isinarray(level.cybercom.mrpukey.var_106f11dd, model_name))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_da7ef8ba
	Namespace: namespace_e44205a2
	Checksum: 0x7B482510
	Offset: 0x1360
	Size: 0x2CA
	Parameters: 3
	Flags: Linked
*/
function function_da7ef8ba(target, var_9bc2efcb = 1, upgraded)
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
	weapon = getweapon("gadget_mrpukey");
	foreach(guy in validtargets)
	{
		if(!cybercom::targetisvalid(guy, weapon))
		{
			continue;
		}
		guy thread function_25411db1(upgraded, 0, self);
		wait(0.05);
	}
}

