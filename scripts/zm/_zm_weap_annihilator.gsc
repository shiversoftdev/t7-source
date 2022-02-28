// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_weap_annihilator;

/*
	Name: __init__sytem__
	Namespace: zm_weap_annihilator
	Checksum: 0x7353509A
	Offset: 0x260
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_annihilator", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_annihilator
	Checksum: 0x873D6CA8
	Offset: 0x2A0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_spawner::register_zombie_death_event_callback(&check_annihilator_death);
	zm_hero_weapon::register_hero_weapon("hero_annihilator");
	level.weaponannihilator = getweapon("hero_annihilator");
}

/*
	Name: check_annihilator_death
	Namespace: zm_weap_annihilator
	Checksum: 0x18BBB6DA
	Offset: 0x308
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function check_annihilator_death(attacker)
{
	if(isdefined(self.damageweapon) && !self.damageweapon === level.weaponnone)
	{
		if(self.damageweapon === level.weaponannihilator)
		{
			self zombie_utility::gib_random_parts();
			gibserverutils::annihilate(self);
		}
	}
}

