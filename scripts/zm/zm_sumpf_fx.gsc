// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\flagsys_shared;

#namespace zm_sumpf_fx;

/*
	Name: main
	Namespace: zm_sumpf_fx
	Checksum: 0x7D23E14
	Offset: 0x1038
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	scriptedfx();
	precachefx();
	level thread fx_overrides();
}

/*
	Name: fx_overrides
	Namespace: zm_sumpf_fx
	Checksum: 0x546D57AB
	Offset: 0x1080
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
	level._effect["doubletap2_light"] = "dlc5/zmhd/fx_perk_doubletap";
	level._effect["additionalprimaryweapon_light"] = "dlc5/zmhd/fx_perk_mule_kick";
}

/*
	Name: scriptedfx
	Namespace: zm_sumpf_fx
	Checksum: 0xEB668EBA
	Offset: 0x1138
	Size: 0x24E
	Parameters: 0
	Flags: Linked
*/
function scriptedfx()
{
	level._effect["hanging_light_fx"] = "env/light/fx_zmb_shino_glow_lantern";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["large_ceiling_dust"] = "maps/zombie/fx_dust_ceiling_impact_lg_mdbrown";
	level._effect["poltergeist"] = "dlc5/zmhd/fx_zombie_couch_effect";
	level._effect["lght_marker_old"] = "dlc5/tomb/fx_tomb_marker";
	level._effect["lght_marker"] = "dlc5/sumpf/fx_marker_hut1_loop";
	level._effect["lght_marker_flare"] = "dlc5/tomb/fx_tomb_marker_fl";
	level._effect["betty_explode"] = "weapon/bouncing_betty/fx_explosion_betty_generic";
	level._effect["betty_trail"] = "weapon/bouncing_betty/fx_betty_trail";
	level._effect["trap_fire"] = "maps/zombie/fx_zombie_fire_trp";
	level._effect["trap_blade"] = "maps/zombie/fx_zombie_chopper_trp";
	level._effect["dog_entrance_start"] = "maps/zombie/fx_zombie_dog_gate_start";
	level._effect["dog_entrance_looping"] = "maps/zombie/fx_zombie_dog_gate_looping";
	level._effect["dog_entrance_ending"] = "maps/zombie/fx_zombie_dog_gate_end";
	level._effect["stub"] = "misc/fx_zombie_perk_lottery";
	level._effect["zombie_perk_smoke_anim"] = "dlc5/sumpf/fx_perk_lottery_smoke_sides_anim";
	level._effect["zombie_perk_start"] = "dlc5/sumpf/fx_perk_lottery_front";
	level._effect["zombie_perk_flash"] = "dlc5/sumpf/fx_perk_lottery_flash";
	level._effect["zombie_perk_end"] = "dlc5/sumpf/fx_perk_lottery_end";
	level._effect["zombie_perk_4th"] = "dlc5/zmhd/fx_perk_lottery_4";
	level._effect["chopper_blur"] = "maps/zombie/fx_zombie_chopper_trp_blur";
}

/*
	Name: precachefx
	Namespace: zm_sumpf_fx
	Checksum: 0x98044540
	Offset: 0x1390
	Size: 0x542
	Parameters: 0
	Flags: Linked
*/
function precachefx()
{
	level._effect["mp_fire_medium"] = "fire/fx_fire_fuel_sm";
	level._effect["mp_fire_large"] = "maps/zombie/fx_zmb_tranzit_fire_lrg";
	level._effect["mp_smoke_ambiance_indoor"] = "maps/mp_maps/fx_mp_smoke_ambiance_indoor";
	level._effect["mp_smoke_ambiance_indoor_misty"] = "maps/mp_maps/fx_mp_smoke_ambiance_indoor_misty";
	level._effect["mp_smoke_ambiance_indoor_sm"] = "maps/mp_maps/fx_mp_smoke_ambiance_indoor_sm";
	level._effect["fx_fog_low_floor_sm"] = "env/smoke/fx_fog_low_floor_sm";
	level._effect["mp_smoke_column_tall"] = "maps/mp_maps/fx_mp_smoke_column_tall";
	level._effect["mp_smoke_column_short"] = "maps/mp_maps/fx_mp_smoke_column_short";
	level._effect["mp_fog_rolling_large"] = "maps/mp_maps/fx_mp_fog_rolling_thick_large_area";
	level._effect["mp_fog_rolling_small"] = "maps/mp_maps/fx_mp_fog_rolling_thick_small_area";
	level._effect["mp_flies_carcass"] = "maps/mp_maps/fx_mp_flies_carcass";
	level._effect["mp_insects_swarm"] = "maps/mp_maps/fx_mp_insect_swarm";
	level._effect["mp_insects_lantern"] = "maps/zombie_old/fx_mp_insects_lantern";
	level._effect["mp_firefly_ambient"] = "maps/mp_maps/fx_mp_firefly_ambient";
	level._effect["mp_firefly_swarm"] = "maps/mp_maps/fx_mp_firefly_swarm";
	level._effect["mp_maggots"] = "maps/mp_maps/fx_mp_maggots";
	level._effect["mp_falling_leaves_elm"] = "maps/mp_maps/fx_mp_falling_leaves_elm";
	level._effect["god_rays_dust_motes"] = "env/light/fx_light_god_rays_dust_motes";
	level._effect["light_ceiling_dspot"] = "env/light/fx_ray_ceiling_amber_dim_sm";
	level._effect["fx_bats_circling"] = "bio/animals/fx_bats_circling";
	level._effect["fx_bats_ambient"] = "maps/mp_maps/fx_bats_ambient";
	level._effect["mp_dragonflies"] = "bio/insects/fx_insects_dragonflies_ambient";
	level._effect["fx_mp_ray_moon_xsm_near"] = "maps/mp_maps/fx_mp_ray_moon_xsm_near";
	level._effect["fx_meteor_ambient"] = "maps/zombie/fx_meteor_ambient";
	level._effect["fx_meteor_flash"] = "maps/zombie/fx_meteor_flash";
	level._effect["fx_meteor_flash_spawn"] = "maps/zombie/fx_meteor_flash_spawn";
	level._effect["fx_meteor_hotspot"] = "maps/zombie/fx_meteor_hotspot";
	level._effect["fx_zm_swamp_fire_torch"] = "fire/fx_zm_swamp_fire_torch";
	level._effect["fx_zm_swamp_fire_detail"] = "fire/fx_zm_swamp_fire_detail";
	level._effect["fx_zm_swamp_glow_lantern"] = "maps/zombie/fx_zm_swamp_glow_lantern";
	level._effect["fx_zm_swamp_glow_lantern_sm"] = "maps/zombie/fx_zm_swamp_glow_lantern_sm";
	level._effect["fx_zm_swamp_glow_int_tinhat\t"] = "maps/zombie/fx_zm_swamp_glow_int_tinhat";
	level._effect["fx_zm_swamp_glow_beacon\t"] = "maps/zombie/fx_zm_swamp_glow_beacon";
	level._effect["zapper_fx"] = "maps/zombie/fx_zombie_zapper_powerbox_on";
	level._effect["zapper"] = "maps/zombie/fx_zombie_electric_trap";
	level._effect["zapper_wall"] = "maps/zombie/fx_zombie_zapper_wall_control_on";
	level._effect["zapper_light_ready"] = "maps/zombie/fx_zm_swamp_light_glow_green";
	level._effect["zapper_light_notready"] = "maps/zombie/fx_zm_swamp_light_glow_red";
	level._effect["elec_room_on"] = "fx_zombie_light_elec_room_on";
	level._effect["elec_md"] = "dlc5/zmhd/fx_elec_player_md";
	level._effect["elec_sm"] = "dlc5/zmhd/fx_elec_player_sm";
	level._effect["elec_torso"] = "zombie/fx_elec_player_torso_zmb";
	level._effect["wire_sparks_oneshot"] = "electrical/fx_elec_wire_spark_dl_oneshot";
	level._effect["elec_trail_one_shot"] = "maps/zombie/fx_zombie_elec_trail_oneshot";
	level._effect["rise_burst_water"] = "maps/zombie/fx_zombie_body_wtr_burst_smpf";
	level._effect["rise_billow_water"] = "maps/zombie/fx_zombie_body_wtr_billow_smpf";
	level._effect["rise_dust_water"] = "maps/zombie/fx_zombie_body_wtr_falling";
	level._effect["fx_light_god_ray_sm_sumpf_warm_v1"] = "env/light/fx_light_god_ray_sm_sumpf_warm_v1";
}

