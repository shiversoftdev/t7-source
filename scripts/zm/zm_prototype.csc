// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_radio;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_prototype_amb;
#using scripts\zm\zm_prototype_barrels;
#using scripts\zm\zm_prototype_ffotd;
#using scripts\zm\zm_prototype_fx;

#namespace zm_prototype;

/*
	Name: __init__sytem__
	Namespace: zm_prototype
	Checksum: 0x98EE5AD8
	Offset: 0x590
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_prototype", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_prototype
	Checksum: 0x28C4F651
	Offset: 0x5D0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		println("");
	#/
}

/*
	Name: function_d9af860b
	Namespace: zm_prototype
	Checksum: 0xCACF6A26
	Offset: 0x600
	Size: 0x1C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_d9af860b()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
}

/*
	Name: main
	Namespace: zm_prototype
	Checksum: 0x6F73405A
	Offset: 0x628
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_prototype_ffotd::main_start();
	zm_prototype_fx::main();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	level._uses_sticky_grenades = 1;
	start_zombie_stuff();
	level thread zm_prototype_amb::main();
	util::waitforclient(0);
	level thread function_6ac83719();
	zm_prototype_ffotd::main_end();
}

/*
	Name: start_zombie_stuff
	Namespace: zm_prototype
	Checksum: 0x3A1E6247
	Offset: 0x6F0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function start_zombie_stuff()
{
	include_weapons();
	load::main();
	_zm_weap_cymbal_monkey::init();
	level thread function_d87a7dcc();
}

/*
	Name: include_weapons
	Namespace: zm_prototype
	Checksum: 0x1C24A6A
	Offset: 0x748
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_prototype_weapons.csv", 1);
}

/*
	Name: function_d87a7dcc
	Namespace: zm_prototype
	Checksum: 0x7B8DE698
	Offset: 0x778
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_d87a7dcc()
{
	var_bd7ba30 = 0;
	while(true)
	{
		if(!level clientfield::get("zombie_power_on"))
		{
			level.power_on = 0;
			if(var_bd7ba30)
			{
				level notify(#"power_controlled_light");
			}
			level util::waittill_any("power_on", "pwr", "ZPO");
		}
		level notify(#"power_controlled_light");
		level util::waittill_any("pwo", "ZPOff");
		var_bd7ba30 = 1;
	}
}

/*
	Name: function_6ac83719
	Namespace: zm_prototype
	Checksum: 0x1FD1531D
	Offset: 0x850
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_6ac83719()
{
	visionset_mgr::init_fog_vol_to_visionset_monitor("zm_prototype", 0.1);
	visionset_mgr::fog_vol_to_visionset_set_suffix("");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zm_prototype");
}

