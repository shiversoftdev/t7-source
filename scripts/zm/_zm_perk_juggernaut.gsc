// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_perk_juggernaut;

/*
	Name: __init__sytem__
	Namespace: zm_perk_juggernaut
	Checksum: 0x38036258
	Offset: 0x3A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_juggernaut", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_juggernaut
	Checksum: 0x8B963AF3
	Offset: 0x3E8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	enable_juggernaut_perk_for_level();
}

/*
	Name: enable_juggernaut_perk_for_level
	Namespace: zm_perk_juggernaut
	Checksum: 0x3626E569
	Offset: 0x408
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function enable_juggernaut_perk_for_level()
{
	zm_perks::register_perk_basic_info("specialty_armorvest", "juggernog", 2500, &"ZOMBIE_PERK_JUGGERNAUT", getweapon("zombie_perk_bottle_jugg"));
	zm_perks::register_perk_precache_func("specialty_armorvest", &juggernaut_precache);
	zm_perks::register_perk_clientfields("specialty_armorvest", &juggernaut_register_clientfield, &juggernaut_set_clientfield);
	zm_perks::register_perk_machine("specialty_armorvest", &juggernaut_perk_machine_setup, &init_juggernaut);
	zm_perks::register_perk_threads("specialty_armorvest", &give_juggernaut_perk, &take_juggernaut_perk);
	zm_perks::register_perk_host_migration_params("specialty_armorvest", "vending_jugg", "jugger_light");
}

/*
	Name: init_juggernaut
	Namespace: zm_perk_juggernaut
	Checksum: 0xCACD49A6
	Offset: 0x550
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function init_juggernaut()
{
	zombie_utility::set_zombie_var("zombie_perk_juggernaut_health", 100);
	zombie_utility::set_zombie_var("zombie_perk_juggernaut_health_upgrade", 150);
}

/*
	Name: juggernaut_precache
	Namespace: zm_perk_juggernaut
	Checksum: 0x363A66AC
	Offset: 0x5A0
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function juggernaut_precache()
{
	if(isdefined(level.juggernaut_precache_override_func))
	{
		[[level.juggernaut_precache_override_func]]();
		return;
	}
	level._effect["jugger_light"] = "zombie/fx_perk_juggernaut_zmb";
	level.machine_assets["specialty_armorvest"] = spawnstruct();
	level.machine_assets["specialty_armorvest"].weapon = getweapon("zombie_perk_bottle_jugg");
	level.machine_assets["specialty_armorvest"].off_model = "p7_zm_vending_jugg";
	level.machine_assets["specialty_armorvest"].on_model = "p7_zm_vending_jugg";
}

/*
	Name: juggernaut_register_clientfield
	Namespace: zm_perk_juggernaut
	Checksum: 0x7F7B6198
	Offset: 0x688
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function juggernaut_register_clientfield()
{
	clientfield::register("clientuimodel", "hudItems.perks.juggernaut", 1, 2, "int");
}

/*
	Name: juggernaut_set_clientfield
	Namespace: zm_perk_juggernaut
	Checksum: 0x6745FF19
	Offset: 0x6C8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function juggernaut_set_clientfield(state)
{
	self clientfield::set_player_uimodel("hudItems.perks.juggernaut", state);
}

/*
	Name: juggernaut_perk_machine_setup
	Namespace: zm_perk_juggernaut
	Checksum: 0x7A1D5D03
	Offset: 0x700
	Size: 0xD0
	Parameters: 4
	Flags: Linked
*/
function juggernaut_perk_machine_setup(use_trigger, perk_machine, bump_trigger, collision)
{
	use_trigger.script_sound = "mus_perks_jugganog_jingle";
	use_trigger.script_string = "jugg_perk";
	use_trigger.script_label = "mus_perks_jugganog_sting";
	use_trigger.longjinglewait = 1;
	use_trigger.target = "vending_jugg";
	perk_machine.script_string = "jugg_perk";
	perk_machine.targetname = "vending_jugg";
	if(isdefined(bump_trigger))
	{
		bump_trigger.script_string = "jugg_perk";
	}
}

/*
	Name: give_juggernaut_perk
	Namespace: zm_perk_juggernaut
	Checksum: 0xD0D1636D
	Offset: 0x7D8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function give_juggernaut_perk()
{
	self zm_perks::perk_set_max_health_if_jugg("specialty_armorvest", 1, 0);
}

/*
	Name: take_juggernaut_perk
	Namespace: zm_perk_juggernaut
	Checksum: 0x9CA19136
	Offset: 0x808
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function take_juggernaut_perk(b_pause, str_perk, str_result)
{
	self zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 1);
}

