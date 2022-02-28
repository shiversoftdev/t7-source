// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_island_fx;

/*
	Name: __init__sytem__
	Namespace: zm_island_fx
	Checksum: 0x249A992E
	Offset: 0x860
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_fx", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_fx
	Checksum: 0x99EC1590
	Offset: 0x8A0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: main
	Namespace: zm_island_fx
	Checksum: 0xD51BDD39
	Offset: 0x8B0
	Size: 0x3AE
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache();
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["bubbles"] = "player/fx_plyr_swim_bubbles_body_blkstn";
	level._effect["current_effect"] = "debris/fx_debris_underwater_current_sgen_os";
	level._effect["vine_door_electric_source_open_fx"] = "dlc2/island/fx_vinegate_machine_open_elec";
	level._effect["vine_door_electric_source_idle_fx"] = "dlc2/island/fx_vinegate_machine_idle_elec";
	level._effect["bunker_door_open_fx"] = "dlc2/island/fx_dust_door_bunker_island";
	level._effect["lab_door_open_fx"] = "dlc2/island/fx_dust_door_lab_island";
	level._effect["scene_light"] = "dlc2/zmb_weapon/fx_wpn_skull_island";
	level._effect["glow_piece"] = "zombie/fx_ritual_glow_key_zod_zmb";
	level._effect["airdrop_plane_smoke"] = "dlc2/island/fx_smk_plane_perk_crash_trail_sm";
	level._effect["islandfx_vending_marathon"] = "dlc2/island/fx_perk_stamin_up_island";
	level._effect["islandfx_vending_sleight"] = "dlc2/island/fx_perk_sleight_of_hand_island";
	level._effect["islandfx_vending_revive"] = "dlc2/island/fx_perk_quick_revive_island";
	level._effect["islandfx_vending_additionalprimaryweapon"] = "dlc2/island/fx_perk_mule_kick_island";
	level._effect["islandfx_vending_jugg"] = "dlc2/island/fx_perk_juggernaut_island";
	level._effect["islandfx_vending_doubletap"] = "dlc2/island/fx_perk_doubletap_island";
	level._effect["portal_3p"] = "zombie/fx_quest_portal_trail_zod_zmb";
	level._effect["spider_queen_spit_attack"] = "dlc2/island/fx_spider_queen_spit_projectile";
	level._effect["spider_queen_spit_impact"] = "dlc2/island/fx_spider_queen_spit_impact";
	level._effect["special_web_dissolve"] = "dlc2/zmb_weapon/fx_mirg_web_dissolve";
	level._effect["special_web_dissolve_ug"] = "dlc2/zmb_weapon/fx_mirg_web_dissolve_ug";
	level._effect["bgb_web_ww_dissolve"] = "dlc2/island/fx_web_bgb_dissolve_mirg";
	level._effect["bgb_web_ww_dissolve_ug"] = "dlc2/island/fx_web_bgb_dissolve_mirg_ug";
	level._effect["perk_web_ww_dissolve"] = "dlc2/island/fx_web_perk_machine_dissolve_mirg";
	level._effect["perk_web_ww_dissolve_ug"] = "dlc2/island/fx_web_perk_machine_dissolve_mirg_ug";
	level._effect["doorbuy_web_ww_dissolve"] = "dlc2/island/fx_vinegate_open_mirg";
	level._effect["doorbuy_web_ww_dissolve_ug"] = "dlc2/island/fx_vinegate_open_mirg_ug";
}

/*
	Name: precache
	Namespace: zm_island_fx
	Checksum: 0x99EC1590
	Offset: 0xC68
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

