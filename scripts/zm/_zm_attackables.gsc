// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_attackables;

/*
	Name: __init__sytem__
	Namespace: zm_attackables
	Checksum: 0xD3AD68F8
	Offset: 0x2F8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_attackables", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_attackables
	Checksum: 0xAB6F11D8
	Offset: 0x340
	Size: 0x1A6
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.attackablecallback = &attackable_callback;
	level.attackables = struct::get_array("scriptbundle_attackables", "classname");
	foreach(attackable in level.attackables)
	{
		attackable.bundle = struct::get_script_bundle("attackables", attackable.scriptbundlename);
		if(isdefined(attackable.target))
		{
			attackable.slot = struct::get_array(attackable.target, "targetname");
		}
		attackable.is_active = 0;
		attackable.health = attackable.bundle.max_health;
		if(getdvarint("zm_attackables") > 0)
		{
			attackable.is_active = 1;
			attackable.health = 1000;
		}
	}
}

/*
	Name: __main__
	Namespace: zm_attackables
	Checksum: 0x99EC1590
	Offset: 0x4F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
}

/*
	Name: get_attackable
	Namespace: zm_attackables
	Checksum: 0xB1B7FE98
	Offset: 0x500
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function get_attackable()
{
	foreach(attackable in level.attackables)
	{
		if(!(isdefined(attackable.is_active) && attackable.is_active))
		{
			continue;
		}
		dist = distance(self.origin, attackable.origin);
		if(dist < attackable.bundle.aggro_distance)
		{
			if(attackable get_attackable_slot(self))
			{
				return attackable;
			}
		}
		/#
			if(getdvarint("") > 1)
			{
				if(attackable get_attackable_slot(self))
				{
					return attackable;
				}
			}
		#/
	}
	return undefined;
}

/*
	Name: get_attackable_slot
	Namespace: zm_attackables
	Checksum: 0x61FB08C
	Offset: 0x668
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function get_attackable_slot(entity)
{
	self clear_slots();
	foreach(slot in self.slot)
	{
		if(!isdefined(slot.entity))
		{
			slot.entity = entity;
			entity.attackable_slot = slot;
			return true;
		}
	}
	return false;
}

/*
	Name: clear_slots
	Namespace: zm_attackables
	Checksum: 0xD7AF7903
	Offset: 0x748
	Size: 0xE4
	Parameters: 0
	Flags: Linked, Private
*/
function private clear_slots()
{
	foreach(slot in self.slot)
	{
		if(!isalive(slot.entity))
		{
			slot.entity = undefined;
			continue;
		}
		if(isdefined(slot.entity.missinglegs) && slot.entity.missinglegs)
		{
			slot.entity = undefined;
		}
	}
}

/*
	Name: activate
	Namespace: zm_attackables
	Checksum: 0x6E4E8D03
	Offset: 0x838
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function activate()
{
	self.is_active = 1;
	if(self.health <= 0)
	{
		self.health = self.bundle.max_health;
	}
}

/*
	Name: deactivate
	Namespace: zm_attackables
	Checksum: 0xB70A0AD9
	Offset: 0x878
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function deactivate()
{
	self.is_active = 0;
}

/*
	Name: do_damage
	Namespace: zm_attackables
	Checksum: 0x1522F874
	Offset: 0x890
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function do_damage(damage)
{
	self.health = self.health - damage;
	self notify(#"attackable_damaged");
	if(self.health <= 0)
	{
		self notify(#"attackable_deactivated");
		if(!(isdefined(self.b_deferred_deactivation) && self.b_deferred_deactivation))
		{
			self deactivate();
		}
	}
}

/*
	Name: attackable_callback
	Namespace: zm_attackables
	Checksum: 0xBF7F2EA3
	Offset: 0x910
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function attackable_callback(entity)
{
	if(entity.archetype === "thrasher" && (self.scriptbundlename === "zm_island_trap_plant_attackable" || self.scriptbundlename === "zm_island_trap_plant_upgraded_attackable"))
	{
		self do_damage(self.health);
	}
	else
	{
		self do_damage(entity.meleeweapon.meleedamage);
	}
}

