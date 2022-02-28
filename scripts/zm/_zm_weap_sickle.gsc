// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_sickle;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_sickle
	Checksum: 0xC6D2E5F9
	Offset: 0x1A0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("sickle", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_sickle
	Checksum: 0x99EC1590
	Offset: 0x1E8
	Size: 0x4
	Parameters: 0
	Flags: Linked, Private
*/
function private __init__()
{
}

/*
	Name: __main__
	Namespace: _zm_weap_sickle
	Checksum: 0xAA07EA7F
	Offset: 0x1F8
	Size: 0x104
	Parameters: 0
	Flags: Linked, Private
*/
function private __main__()
{
	if(isdefined(level.var_c81f7742))
	{
		cost = level.var_c81f7742;
	}
	else
	{
		cost = 3000;
	}
	prompt = &"ZOMBIE_WEAPONCOSTONLY_CFILL";
	if(!(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled))
	{
		prompt = &"DLC5_WEAPON_SICKLE_BUY";
	}
	zm_melee_weapon::init("sickle_knife", "sickle_flourish", "knife_ballistic_sickle", "knife_ballistic_sickle_upgraded", cost, "sickle_upgrade", prompt, "sickle", undefined);
	zm_melee_weapon::set_fallback_weapon("sickle_knife", "zombie_fists_sickle");
	zm_weapons::add_retrievable_knife_init_name("knife_ballistic_sickle");
	zm_weapons::add_retrievable_knife_init_name("knife_ballistic_sickle_upgraded");
}

/*
	Name: init
	Namespace: _zm_weap_sickle
	Checksum: 0x99EC1590
	Offset: 0x308
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function init()
{
}

