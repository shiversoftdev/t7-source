// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_bowie;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_bowie
	Checksum: 0x40193374
	Offset: 0x198
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bowie_knife", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_bowie
	Checksum: 0x99EC1590
	Offset: 0x1E0
	Size: 0x4
	Parameters: 0
	Flags: Linked, Private
*/
function private __init__()
{
}

/*
	Name: __main__
	Namespace: _zm_weap_bowie
	Checksum: 0xD2DB652E
	Offset: 0x1F0
	Size: 0x104
	Parameters: 0
	Flags: Linked, Private
*/
function private __main__()
{
	if(isdefined(level.bowie_cost))
	{
		cost = level.bowie_cost;
	}
	else
	{
		cost = 3000;
	}
	prompt = &"ZOMBIE_WEAPONCOSTONLY_CFILL";
	if(!(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled))
	{
		prompt = &"ZOMBIE_WEAPON_BOWIE_BUY";
	}
	zm_melee_weapon::init("bowie_knife", "bowie_flourish", "knife_ballistic_bowie", "knife_ballistic_bowie_upgraded", cost, "bowie_upgrade", prompt, "bowie", undefined);
	zm_melee_weapon::set_fallback_weapon("bowie_knife", "zombie_fists_bowie");
	zm_weapons::add_retrievable_knife_init_name("knife_ballistic_bowie");
	zm_weapons::add_retrievable_knife_init_name("knife_ballistic_bowie_upgraded");
}

/*
	Name: init
	Namespace: _zm_weap_bowie
	Checksum: 0x99EC1590
	Offset: 0x300
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function init()
{
}

