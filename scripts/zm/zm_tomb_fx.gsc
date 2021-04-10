// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_fx;

/*
	Name: main
	Namespace: zm_tomb_fx
	Checksum: 0xE6EE5416
	Offset: 0x10E0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_createfx_fx();
	precache_scripted_fx();
	level thread fx_overrides();
}

/*
	Name: precache_scripted_fx
	Namespace: zm_tomb_fx
	Checksum: 0xC1A06D3D
	Offset: 0x1128
	Size: 0x382
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["poltergeist"] = "misc/fx_zombie_couch_effect";
	level._effect["door_steam"] = "dlc5/tomb/fx_tomb_dieselmagic_doors_steam";
	level._effect["door_steam_rotated"] = "dlc5/tomb/fx_tomb_dieselmagic_doors_steam_rotated";
	level._effect["zomb_gib"] = "maps/zombie/fx_zmb_tranzit_lava_torso_explo";
	level._effect["digging"] = "dlc5/tomb/fx_tomb_shovel_dig";
	level._effect["staff_soul"] = "dlc5/zmb_weapon/fx_staff_charge_souls";
	level._effect["staff_charge"] = "dlc5/zmb_weapon/fx_staff_charge";
	level._effect["air_puzzle_smoke"] = "dlc5/tomb/fx_tomb_puzzle_air_smoke";
	level._effect["elec_piano_glow"] = "dlc5/tomb/fx_tomb_puzzle_elec_sparks";
	level._effect["fire_ash_explosion"] = "dlc5/tomb/fx_tomb_puzzle_fire_exp_ash";
	level._effect["fire_torch"] = "dlc5/tomb/fx_tomb_puzzle_fire_torch";
	level._effect["ice_explode"] = "dlc5/tomb/fx_tomb_puzzle_ice_pipe_burst";
	level._effect["puzzle_orb_trail"] = "dlc5/tomb/fx_tomb_puzzle_plinth_trail";
	level._effect["teleport_1p"] = "dlc5/tomb/fx_teleport_1p";
	level._effect["teleport_3p"] = "dlc5/tomb/fx_teleport_3p";
	level._effect["teleport_air"] = "dlc5/tomb/fx_portal_air";
	level._effect["teleport_elec"] = "dlc5/tomb/fx_portal_elec";
	level._effect["teleport_fire"] = "dlc5/tomb/fx_portal_fire";
	level._effect["teleport_ice"] = "dlc5/tomb/fx_portal_ice";
	level._effect["tesla_elec_kill"] = "dlc5/tomb/fx_115_generator_tesla_kill";
	level._effect["capture_complete"] = "dlc5/tomb/fx_tomb_capture_complete";
	level._effect["zone_capture_zombie_spawn"] = "dlc5/tomb/fx_tomb_emergence_spawn";
	level._effect["ee_beam"] = "dlc5/tomb/fx_tomb_ee_beam";
	level._effect["biplane_explode"] = "dlc5/tomb/fx_tomb_explo_airplane";
	level._effect["special_glow"] = "dlc5/tomb/fx_elem_reveal_glow";
	level._effect["building_dust"] = "dlc5/tomb/fx_zmb_buildable_assemble_dust";
	level._effect["couch_fx"] = "dlc5/tomb/fx_tomb_debris_blocker";
	level._effect["mech_booster_landing"] = "maps/zombie_tomb/fx_tomb_mech_jump_landing";
	level._effect["lght_marker"] = "dlc5/tomb/fx_tomb_marker";
	level._effect["lght_marker_flare"] = "dlc5/tomb/fx_tomb_marker_fl";
	level._effect["poltergeist"] = "tools/fx_null";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_tomb_fx
	Checksum: 0x390A24E2
	Offset: 0x14B8
	Size: 0x40E
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["fx_sky_dist_aa_tracers"] = "maps/zombie_tomb/fx_tomb_sky_dist_aa_tracers";
	level._effect["fx_tomb_vortex_glow"] = "maps/zombie_tomb/fx_tomb_vortex_glow";
	level._effect["fx_pack_a_punch"] = "maps/zombie_tomb/fx_tomb_pack_a_punch_light_beams";
	level._effect["fx_tomb_dust_fall"] = "maps/zombie_tomb/fx_tomb_dust_fall";
	level._effect["fx_tomb_dust_fall_lg"] = "maps/zombie_tomb/fx_tomb_dust_fall_lg";
	level._effect["fx_tomb_embers_flat"] = "maps/zombie_tomb/fx_tomb_embers_flat";
	level._effect["fx_tomb_fire_lg"] = "maps/zombie_tomb/fx_tomb_fire_lg";
	level._effect["fx_tomb_fire_sm"] = "maps/zombie_tomb/fx_tomb_fire_sm";
	level._effect["fx_tomb_fire_line_sm"] = "maps/zombie_tomb/fx_tomb_fire_line_sm";
	level._effect["fx_tomb_fire_sm_smolder"] = "maps/zombie_tomb/fx_tomb_fire_sm_smolder";
	level._effect["fx_tomb_ground_fog"] = "maps/zombie_tomb/fx_tomb_ground_fog";
	level._effect["fx_tomb_sparks"] = "dlc5/tomb/fx_tomb_puzzle_elec_sparks";
	level._effect["fx_tomb_sparks_sm"] = "dlc5/tomb/fx_tomb_puzzle_elec_sparks_sm";
	level._effect["fx_tomb_water_drips"] = "maps/zombie_tomb/fx_tomb_water_drips";
	level._effect["fx_tomb_water_drips_sm"] = "maps/zombie_tomb/fx_tomb_water_drips_sm";
	level._effect["fx_tomb_smoke_pillar_xlg"] = "maps/zombie_tomb/fx_tomb_smoke_pillar_xlg";
	level._effect["fx_tomb_godray_md"] = "maps/zombie_tomb/fx_tomb_godray_md";
	level._effect["fx_tomb_godray_mist_md"] = "maps/zombie_tomb/fx_tomb_godray_mist_md";
	level._effect["fx_tomb_dust_motes_md"] = "maps/zombie_tomb/fx_tomb_dust_motes_md";
	level._effect["fx_tomb_dust_motes_lg"] = "maps/zombie_tomb/fx_tomb_dust_motes_lg";
	level._effect["fx_tomb_light_md"] = "maps/zombie_tomb/fx_tomb_light_md";
	level._effect["fx_tomb_light_lg"] = "maps/zombie_tomb/fx_tomb_light_lg";
	level._effect["fx_tomb_light_expensive"] = "maps/zombie_tomb/fx_tomb_light_expensive";
	level._effect["fx_tomb_steam_md"] = "maps/zombie_tomb/fx_tomb_steam_md";
	level._effect["fx_tomb_steam_lg"] = "maps/zombie_tomb/fx_tomb_steam_lg";
	level._effect["fx_tomb_church_fire_vista"] = "maps/zombie_tomb/fx_tomb_church_fire_vista";
	level._effect["fx_tomb_church_custom"] = "maps/zombie_tomb/fx_tomb_church_custom";
	level._effect["fx_tomb_chamber_glow"] = "maps/zombie_tomb/fx_tomb_chamber_glow";
	level._effect["fx_tomb_chamber_glow_blue"] = "maps/zombie_tomb/fx_tomb_chamber_glow_blue";
	level._effect["fx_tomb_chamber_glow_purple"] = "maps/zombie_tomb/fx_tomb_chamber_glow_purple";
	level._effect["fx_tomb_chamber_glow_yellow"] = "maps/zombie_tomb/fx_tomb_chamber_glow_yellow";
	level._effect["fx_tomb_chamber_glow_red"] = "maps/zombie_tomb/fx_tomb_chamber_glow_red";
	level._effect["fx_tomb_chamber_walls_impact"] = "maps/zombie_tomb/fx_tomb_chamber_walls_impact";
	level._effect["fx_tomb_crafting_chamber_glow"] = "maps/zombie_tomb/fx_tomb_crafting_chamber_glow";
	level._effect["fx_tomb_probe_elec_on"] = "maps/zombie_tomb/fx_tomb_probe_elec_on";
	level._effect["fx_tomb_robot_ambient"] = "maps/zombie_tomb/fx_tomb_robot_ambient";
	level._effect["fx_tomb_skybox_vortex"] = "maps/zombie_tomb/fx_tomb_skybox_vortex";
}

/*
	Name: fx_overrides
	Namespace: zm_tomb_fx
	Checksum: 0xE2E65D39
	Offset: 0x18D0
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function fx_overrides()
{
	level flagsys::wait_till("load_main_complete");
	level._effect["jugger_light"] = "dlc5/zmhd/fx_perk_juggernaut";
	level._effect["revive_light"] = "dlc5/zmhd/fx_perk_quick_revive";
	level._effect["sleight_light"] = "dlc5/zmhd/fx_perk_sleight_of_hand";
	level._effect["doubletap2_light"] = "dlc5/zmhd/fx_perk_doubletap";
	level._effect["additionalprimaryweapon_light"] = "dlc5/zmhd/fx_perk_mule_kick";
	level._effect["deadshot_light"] = "dlc5/zmhd/fx_perk_daiquiri";
	level._effect["marathon_light"] = "dlc5/zmhd/fx_perk_stamin_up";
	level._effect["widow_light"] = "dlc5/zmhd/fx_perk_widows_wine";
}

