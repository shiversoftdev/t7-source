// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_cymbal_monkey;

/*
	Name: init
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0xB8440E1B
	Offset: 0x110
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(isdefined(level.legacy_cymbal_monkey) && level.legacy_cymbal_monkey)
	{
		level.cymbal_monkey_model = "weapon_zombie_monkey_bomb";
	}
	else
	{
		level.cymbal_monkey_model = "wpn_t7_zmb_monkey_bomb_world";
	}
	if(!zm_weapons::is_weapon_included(getweapon("cymbal_monkey")))
	{
		return;
	}
}

