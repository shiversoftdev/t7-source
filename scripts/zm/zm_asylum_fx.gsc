// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace zm_asylum_fx;

/*
	Name: main
	Namespace: zm_asylum_fx
	Checksum: 0x56C7900A
	Offset: 0x10C8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_scripted_fx();
	precache_createfx_fx();
	level thread fx_overrides();
}

/*
	Name: precache_createfx_fx
	Namespace: zm_asylum_fx
	Checksum: 0x686713E2
	Offset: 0x1110
	Size: 0x622
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["god_rays_small"] = "env/light/fx_light_god_ray_sm_single";
	level._effect["god_rays_dust_motes"] = "env/light/fx_light_god_rays_dust_motes";
	level._effect["light_ceiling_dspot"] = "env/light/fx_ray_ceiling_amber_dim_sm";
	level._effect["dlight_fire_glow"] = "env/light/fx_dlight_fire_glow";
	level._effect["fire_detail"] = "env/fire/fx_fire_debris_xsmall";
	level._effect["fire_static_small"] = "env/fire/fx_static_fire_sm_ndlight";
	level._effect["fire_static_blk_smk"] = "env/fire/fx_static_fire_md_ndlight";
	level._effect["fire_column_creep_xsm"] = "env/fire/fx_fire_column_creep_xsm";
	level._effect["fire_column_creep_sm"] = "env/fire/fx_fire_column_creep_sm";
	level._effect["fire_distant_150_600"] = "env/fire/fx_fire_150x600_tall_distant";
	level._effect["fire_window"] = "env/fire/fx_fire_win_nsmk_0x35y50z";
	level._effect["fire_tree_trunk"] = "maps/mp_maps/fx_mp_fire_tree_trunk";
	level._effect["fire_rubble_sm_column"] = "maps/mp_maps/fx_mp_fire_rubble_small_column";
	level._effect["fire_rubble_sm_column_smldr"] = "maps/mp_maps/fx_mp_fire_rubble_small_column_smldr";
	level._effect["ash_and_embers"] = "env/fire/fx_ash_embers_light";
	level._effect["smoke_room_fill"] = "maps/ber2/fx_smoke_fill_indoor";
	level._effect["smoke_window_out_small"] = "env/smoke/fx_smoke_door_top_exit_drk";
	level._effect["smoke_plume_xlg_slow_blk"] = "maps/ber2/fx_smk_plume_xlg_slow_blk_w";
	level._effect["smoke_hallway_faint_dark"] = "env/smoke/fx_smoke_hallway_faint_dark";
	level._effect["brush_smoke_smolder_sm"] = "env/smoke/fx_smoke_brush_smolder_md";
	level._effect["smoke_fire_column_short"] = "maps/mp_maps/fx_mp_smoke_fire_column_short";
	level._effect["smoke_impact_smolder_w"] = "env/smoke/fx_smoke_crater_w";
	level._effect["smoke_column_tall"] = "maps/mp_maps/fx_mp_smoke_column_tall";
	level._effect["fog_thick"] = "env/smoke/fx_fog_rolling_thick_zombie";
	level._effect["fog_low_floor"] = "env/smoke/fx_fog_low_floor_sm";
	level._effect["fog_low_thick"] = "env/smoke/fx_fog_low_thick_sm";
	level._effect["blood_drips"] = "system_elements/fx_blood_drips_looped_decal";
	level._effect["insect_lantern"] = "maps/mp_maps/fx_mp_insects_lantern";
	level._effect["insect_swarm"] = "maps/mp_maps/fx_mp_insect_swarm";
	level._effect["insect_flies_carcass"] = "maps/mp_maps/fx_mp_flies_carcass";
	level._effect["water_spill_fall"] = "maps/mp_maps/fx_mp_water_spill";
	level._effect["water_leak_runner"] = "env/water/fx_water_leak_runner_100";
	level._effect["water_spill_splash"] = "maps/mp_maps/fx_mp_water_spill_splash";
	level._effect["water_heavy_leak"] = "env/water/fx_water_drips_hvy";
	level._effect["water_drip_sm_area"] = "maps/mp_maps/fx_mp_water_drip";
	level._effect["water_spill_long"] = "maps/mp_maps/fx_mp_water_spill_long";
	level._effect["water_drips_hvy_long"] = "maps/mp_maps/fx_mp_water_drips_hvy_long";
	level._effect["water_spill_splatter"] = "maps/mp_maps/fx_mp_water_spill_splatter";
	level._effect["water_splash_small"] = "maps/mp_maps/fx_mp_water_splash_small";
	level._effect["wire_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["wire_sparks_blue"] = "env/electrical/fx_elec_wire_spark_burst_blue";
	level._effect["betty_explode"] = "weapon/bouncing_betty/fx_explosion_betty_generic";
	level._effect["betty_trail"] = "weapon/bouncing_betty/fx_betty_trail";
	level._effect["zapper"] = "dlc0/factory/fx_elec_trap_factory";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["wire_sparks_oneshot"] = "env/electrical/fx_elec_wire_spark_dl_oneshot";
	level._effect["dog_entrance"] = "maps/zombie/fx_zombie_fire_trp";
	level._effect["fx_zm_asylum_fire_tree"] = "maps/zombie/fx_zm_asylum_fire_tree";
	level._effect["fx_zm_asylum_fire_sm"] = "maps/zombie/fx_zm_asylum_fire_sm";
	level._effect["fx_zm_asylum_fire_md"] = "maps/zombie/fx_zm_asylum_fire_md";
	level._effect["fx_zm_asylum_fire_lg"] = "maps/zombie/fx_zm_asylum_fire_lg";
	level._effect["fx_light_godray_md_asylum"] = "maps/zombie/fx_zm_asylum_godray_md";
	level._effect["fx_zm_asylum_ray_fire"] = "maps/zombie/fx_zm_asylum_ray_fire";
	level._effect["fx_zm_asylum_ray_fire_thin"] = "maps/zombie/fx_zm_asylum_ray_fire_thin";
	level._effect["fx_zm_proto_fire_detail"] = "maps/zombie/fx_zm_proto_fire_detail";
	level._effect["fx_zm_asylum_water_leak"] = "maps/zombie/fx_zm_asylum_water_leak";
}

/*
	Name: precache_scripted_fx
	Namespace: zm_asylum_fx
	Checksum: 0xDAC18E90
	Offset: 0x1740
	Size: 0x1DE
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["zombie_grain"] = "misc/fx_zombie_grain_cloud";
	level._effect["large_ceiling_dust"] = "maps/zombie/fx_dust_ceiling_impact_lg_mdbrown";
	level._effect["poltergeist"] = "dlc5/zmhd/fx_zombie_couch_effect";
	level._effect["chair_light_fx"] = "env/light/fx_glow_hanginglamp";
	level._effect["lght_marker"] = "dlc5/tomb/fx_tomb_marker";
	level._effect["lght_marker_flare"] = "dlc5/tomb/fx_tomb_marker_fl";
	level._effect["electric_short_oneshot"] = "dlc5/zmhd/fx_elec_sparking_oneshot";
	level._effect["electric_current"] = "dlc5/zmhd/fx_zombie_elec_trail";
	level._effect["zapper_fx"] = "dlc5/zmhd/fx_zombie_zapper_powerbox_on";
	level._effect["zapper_wall"] = "dlc5/zmhd/fx_zombie_zapper_wall_control_on";
	level._effect["zapper_light_ready"] = "dlc5/zmhd/fx_zombie_zapper_light_green";
	level._effect["zapper_light_notready"] = "dlc5/zmhd/fx_zombie_zapper_light_red";
	level._effect["elec_room_on"] = "maps/zombie/fx_zombie_light_elec_room_on";
	level._effect["elec_md"] = "dlc5/zmhd/fx_elec_player_md";
	level._effect["elec_sm"] = "dlc5/zmhd/fx_elec_player_sm";
	level._effect["elec_torso"] = "dlc5/zmhd/fx_elec_player_torso";
	level._effect["elec_trail_one_shot"] = "maps/zombie/fx_zombie_elec_trail_oneshot";
}

/*
	Name: fx_overrides
	Namespace: zm_asylum_fx
	Checksum: 0xE545C443
	Offset: 0x1928
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function fx_overrides()
{
	level flagsys::wait_till("load_main_complete");
	level._effect["jugger_light"] = "dlc5/zmhd/fx_perk_juggernaut";
	level._effect["revive_light"] = "dlc5/zmhd/fx_perk_quick_revive";
	level._effect["sleight_light"] = "dlc5/zmhd/fx_perk_sleight_of_hand";
	level._effect["doubletap2_light"] = "dlc5/asylum/fx_perk_doubletap";
	level._effect["additionalprimaryweapon_light"] = "dlc5/zmhd/fx_perk_mule_kick";
}

