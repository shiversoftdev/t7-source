// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_fx;

/*
	Name: main
	Namespace: zm_genesis_fx
	Checksum: 0xC0D1F88
	Offset: 0x4F8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_scripted_fx();
	precache_createfx_fx();
}

/*
	Name: precache_scripted_fx
	Namespace: zm_genesis_fx
	Checksum: 0xD28A30E
	Offset: 0x528
	Size: 0x16E
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["portal_3p"] = "zombie/fx_quest_portal_trail_zod_zmb";
	level._effect["beast_return_aoe_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["fx_margwa_explo_head_aoe_zod_zmb"] = "zombie/fx_margwa_explo_head_aoe_zod_zmb";
	level._effect["raps_meteor_fire"] = "zombie/fx_meatball_trail_sky_zod_zmb";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["keeper_spawn"] = "zombie/fx_portal_keeper_spawn_zod_zmb";
	level._effect["pap_cord_impact"] = "impacts/fx_bul_impact_blood_body_fatal_zmb";
	level._effect["fury_ground_tell_fx"] = "zombie/fx_meatball_impact_ground_tell_zod_zmb";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_genesis_fx
	Checksum: 0x99EC1590
	Offset: 0x6A0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
}

/*
	Name: function_2c301fae
	Namespace: zm_genesis_fx
	Checksum: 0xCD6F94EE
	Offset: 0x6B0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_2c301fae()
{
	level thread function_12901f9a();
	level thread function_7eea24df();
}

/*
	Name: function_12901f9a
	Namespace: zm_genesis_fx
	Checksum: 0x1EF8872A
	Offset: 0x6F0
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_12901f9a()
{
	level._effect["jugger_light"] = "dlc4/genesis/fx_perk_juggernaut";
	level._effect["revive_light"] = "dlc4/genesis/fx_perk_quick_revive";
	level._effect["sleight_light"] = "dlc4/genesis/fx_perk_sleight_of_hand";
	level._effect["doubletap2_light"] = "dlc4/genesis/fx_perk_doubletap";
	level._effect["marathon_light"] = "dlc4/genesis/fx_perk_stamin_up";
	level._effect["additionalprimaryweapon_light"] = "dlc4/genesis/fx_perk_mule_kick";
}

/*
	Name: function_7eea24df
	Namespace: zm_genesis_fx
	Checksum: 0x46C5FB05
	Offset: 0x7A8
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function function_7eea24df()
{
	level._effect["lght_marker"] = "dlc4/genesis/fx_weapon_box_marker_genesis";
}

