// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_castle_perks;

/*
	Name: init
	Namespace: zm_castle_perks
	Checksum: 0xC2BE8130
	Offset: 0x450
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "perk_light_doubletap", 5000, 1, "int");
	clientfield::register("world", "perk_light_juggernaut", 5000, 1, "int");
	clientfield::register("world", "perk_light_mule_kick", 5000, 1, "int");
	clientfield::register("world", "perk_light_quick_revive", 5000, 1, "int");
	clientfield::register("world", "perk_light_speed_cola", 5000, 1, "int");
	clientfield::register("world", "perk_light_staminup", 5000, 1, "int");
	clientfield::register("world", "perk_light_widows_wine", 5000, 1, "int");
	thread function_9a03e439();
	thread function_b5c4c30e();
}

/*
	Name: function_9a03e439
	Namespace: zm_castle_perks
	Checksum: 0x2898FD17
	Offset: 0x5D0
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_9a03e439()
{
	level.initial_quick_revive_power_off = 1;
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	thread function_5508b348();
	thread function_4a2261fa();
	thread function_6753e7bb();
	thread function_55b919e6();
	thread function_e840e164();
	thread function_a41cf549();
	thread function_8b929f79();
}

/*
	Name: function_b5c4c30e
	Namespace: zm_castle_perks
	Checksum: 0x380EE4DA
	Offset: 0x698
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function function_b5c4c30e()
{
	wait(1);
	level flag::wait_till("start_zombie_round_logic");
	wait(1);
	if(!level flag::get("solo_game"))
	{
		level flag::wait_till("power_on");
	}
	level notify(#"revive_on");
}

/*
	Name: function_5508b348
	Namespace: zm_castle_perks
	Checksum: 0x83A9FDD1
	Offset: 0x718
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_5508b348()
{
	level waittill(#"revive_on");
	exploder::exploder("lgt_vending_quick_revive_castle");
	clientfield::set("perk_light_quick_revive", 1);
	level flag::wait_till("solo_revive");
	exploder::exploder_stop("lgt_vending_quick_revive_castle");
	clientfield::set("perk_light_quick_revive", 0);
}

/*
	Name: function_4a2261fa
	Namespace: zm_castle_perks
	Checksum: 0x788F0AE5
	Offset: 0x7C0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_4a2261fa()
{
	level waittill(#"widows_wine_on");
	clientfield::set("perk_light_widows_wine", 1);
}

/*
	Name: function_6753e7bb
	Namespace: zm_castle_perks
	Checksum: 0x80708ECB
	Offset: 0x7F8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_6753e7bb()
{
	level waittill(#"additionalprimaryweapon_on");
	clientfield::set("perk_light_mule_kick", 1);
}

/*
	Name: function_55b919e6
	Namespace: zm_castle_perks
	Checksum: 0x1847F248
	Offset: 0x830
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_55b919e6()
{
	level waittill(#"marathon_on");
	level clientfield::set("perk_light_staminup", 1);
}

/*
	Name: function_e840e164
	Namespace: zm_castle_perks
	Checksum: 0x51E79376
	Offset: 0x870
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_e840e164()
{
	level waittill(#"sleight_on");
	level clientfield::set("perk_light_speed_cola", 1);
}

/*
	Name: function_a41cf549
	Namespace: zm_castle_perks
	Checksum: 0x5510F6A1
	Offset: 0x8B0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_a41cf549()
{
	level waittill(#"juggernog_on");
	level clientfield::set("perk_light_juggernaut", 1);
}

/*
	Name: function_8b929f79
	Namespace: zm_castle_perks
	Checksum: 0x789FC7FB
	Offset: 0x8F0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_8b929f79()
{
	level waittill(#"doubletap_on");
	level clientfield::set("perk_light_doubletap", 1);
}

