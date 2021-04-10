// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\flagsys_shared;

#namespace zm_theater_fx;

/*
	Name: main
	Namespace: zm_theater_fx
	Checksum: 0x192968B2
	Offset: 0x1690
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
	Namespace: zm_theater_fx
	Checksum: 0x4404D4E6
	Offset: 0x16D8
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
	Namespace: zm_theater_fx
	Checksum: 0xE4B9AC2F
	Offset: 0x1790
	Size: 0x2A2
	Parameters: 0
	Flags: Linked
*/
function scriptedfx()
{
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["large_ceiling_dust"] = "maps/zombie/fx_dust_ceiling_impact_lg_mdbrown";
	level._effect["poltergeist"] = "zombie/fx_barrier_buy_zmb";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["dog_breath"] = "dlc5/zmhd/fx_zombie_dog_breath";
	level._effect["rise_burst"] = "maps/zombie/fx_mp_zombie_hand_dirt_burst";
	level._effect["rise_billow"] = "maps/zombie/fx_mp_zombie_body_dirt_billowing";
	level._effect["rise_dust"] = "maps/zombie/fx_mp_zombie_body_dust_falling";
	level._effect["quad_grnd_dust_spwnr"] = "maps/zombie/fx_zombie_crawler_grnd_dust_spwnr";
	level._effect["quad_grnd_dust"] = "maps/zombie/fx_zombie_crawler_grnd_dust";
	level._effect["lght_marker"] = "dlc5/tomb/fx_tomb_marker";
	level._effect["lght_marker_flare"] = "dlc5/tomb/fx_tomb_marker_fl";
	level._effect["electric_current"] = "misc/fx_zombie_elec_trail";
	level._effect["zapper_fx"] = "maps/zombie/fx_zombie_zapper_powerbox_on";
	level._effect["zapper"] = "maps/zombie/fx_zombie_electric_trap";
	level._effect["zapper_tall"] = "maps/zombie/fx_zm_theater_electric_trap";
	level._effect["zapper_wall"] = "maps/zombie/fx_zombie_zapper_wall_control_on";
	level._effect["zapper_light_ready"] = "maps/zombie/fx_zombie_zapper_light_green";
	level._effect["zapper_light_notready"] = "maps/zombie/fx_zombie_zapper_light_red";
	level._effect["elec_md"] = "electrical/fx_elec_player_md";
	level._effect["elec_sm"] = "electrical/fx_elec_player_sm";
	level._effect["elec_torso"] = "zombie/fx_elec_player_torso_zmb";
	level._effect["fire_trap"] = "dlc5/zmb_traps/fx_fire_trap_med_loop";
	level._effect["auto_turret_light"] = "dlc5/zmhd/fx_zombie_auto_turret_light";
}

/*
	Name: precachefx
	Namespace: zm_theater_fx
	Checksum: 0xA45B0CBA
	Offset: 0x1A40
	Size: 0x756
	Parameters: 0
	Flags: Linked
*/
function precachefx()
{
	level._effect["fx_mp_smoke_thick_indoor"] = "maps/zombie/fx_mp_smoke_thick_indoor";
	level._effect["fx_mp_smoke_amb_indoor_misty"] = "maps/zombie/fx_zombie_theater_smoke_amb_indoor";
	level._effect["fx_smoke_smolder_md_gry"] = "maps/zombie/fx_smoke_smolder_md_gry";
	level._effect["fx_smk_smolder_sm"] = "env/smoke/fx_smk_smolder_sm";
	level._effect["fx_mp_smoke_crater"] = "maps/zombie/fx_mp_smoke_crater";
	level._effect["fx_mp_smoke_sm_slow"] = "maps/zombie/fx_mp_smoke_sm_slow";
	level._effect["fx_mp_fog_low"] = "maps/mp_maps/fx_mp_fog_low";
	level._effect["fx_zombie_theater_fog_lg"] = "maps/zombie/fx_zombie_theater_fog_lg";
	level._effect["fx_zombie_theater_fog_xlg"] = "maps/zombie/fx_zombie_theater_fog_xlg";
	level._effect["fx_mp_fog_ground_md"] = "maps/mp_maps/fx_mp_fog_ground_md";
	level._effect["fx_water_drip_light_long"] = "env/water/fx_water_drip_light_long";
	level._effect["fx_water_drip_light_short"] = "env/water/fx_water_drip_light_short";
	level._effect["fx_mp_ray_light_sm"] = "env/light/fx_light_godray_overcast_sm";
	level._effect["fx_mp_ray_light_md"] = "maps/zombie/fx_mp_ray_overcast_md";
	level._effect["fx_mp_ray_light_lg"] = "maps/zombie/fx_light_godray_overcast_lg";
	level._effect["fx_mp_dust_motes"] = "maps/zombie/fx_mp_ray_motes_lg";
	level._effect["fx_mp_dust_mote_pcloud_sm"] = "maps/zombie/fx_mp_dust_mote_pcloud_sm";
	level._effect["fx_mp_dust_mote_pcloud_md"] = "maps/zombie/fx_mp_dust_mote_pcloud_md";
	level._effect["fx_mp_pipe_steam"] = "dlc5/tomb/fx_steam_leak_xsm";
	level._effect["fx_mp_pipe_steam_random"] = "maps/zombie/fx_mp_pipe_steam_random";
	level._effect["fx_mp_fumes_vent_sm_int"] = "maps/mp_maps/fx_mp_fumes_vent_sm_int";
	level._effect["fx_mp_fumes_vent_xsm_int"] = "maps/mp_maps/fx_mp_fumes_vent_xsm_int";
	level._effect["fx_mp_elec_spark_burst_xsm_thin_runner"] = "maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin_runner";
	level._effect["fx_mp_elec_spark_burst_sm_runner"] = "maps/mp_maps/fx_mp_elec_spark_burst_sm_runner";
	level._effect["fx_mp_light_lamp"] = "maps/zombie_old/fx_mp_light_lamp";
	level._effect["fx_mp_light_corona_cool"] = "maps/zombie/fx_mp_light_corona_cool";
	level._effect["fx_mp_light_corona_bulb_ceiling"] = "maps/zombie/fx_mp_light_corona_bulb_ceiling";
	level._effect["fx_pent_tinhat_light"] = "maps/pentagon/fx_pent_tinhat_light";
	level._effect["fx_light_floodlight_bright"] = "maps/zombie/fx_zombie_light_floodlight_bright";
	level._effect["fx_light_overhead_sm_amber"] = "maps/zombie/fx_zombie_overhead_sm_amber";
	level._effect["fx_light_overhead_sm_amber_flkr"] = "maps/zombie/fx_zombie_overhead_sm_amber_flkr";
	level._effect["fx_light_overhead_sm_blue"] = "maps/zombie/fx_zombie_overhead_sm_blu";
	level._effect["fx_light_overhead_sm_blue_flkr"] = "maps/zombie/fx_zombie_overhead_sm_blu_flkr";
	level._effect["fx_mp_birds_circling"] = "maps/zombie/fx_mp_birds_circling";
	level._effect["fx_mp_insects_lantern"] = "maps/zombie_old/fx_mp_insects_lantern";
	level._effect["fx_insects_swarm_md_light"] = "bio/insects/fx_insects_swarm_md_light";
	level._effect["fx_insects_maggots"] = "bio/insects/fx_insects_maggots_sm";
	level._effect["fx_insects_moths_light_source"] = "bio/insects/fx_insects_moths_light_source";
	level._effect["fx_insects_moths_light_source_md"] = "bio/insects/fx_insects_moths_light_source_md";
	level._effect["fx_pent_movie_projector"] = "maps/pentagon/fx_pent_movie_projector";
	level._effect["fx_zombie_light_theater_blue"] = "maps/zombie/fx_zombie_light_theater_blue";
	level._effect["fx_zombie_light_theater_green"] = "maps/zombie/fx_zombie_light_theater_green";
	level._effect["fx_zombie_theater_projector_beam"] = "maps/zombie/fx_zombie_theater_projector_beam";
	level._effect["fx_zombie_theater_projector_screen"] = "maps/zombie/fx_zombie_theater_projection_screen";
	level._effect["projector_screen_0"] = "maps/zombie/fx_zombie_theater_screen_0";
	level._effect["projector_screen_1"] = "maps/zombie/fx_zombie_theater_screen_1";
	level._effect["projector_screen_2"] = "maps/zombie/fx_zombie_theater_screen_2";
	level._effect["projector_screen_3"] = "maps/zombie/fx_zombie_theater_screen_3";
	level._effect["fx_transporter_beam"] = "maps/zombie/fx_transporter_beam";
	level._effect["fx_transporter_pad_start"] = "maps/zombie/fx_transporter_pad_start";
	level._effect["fx_transporter_start"] = "maps/zombie/fx_transporter_start";
	level._effect["fx_transporter_ambient"] = "maps/zombie/fx_transporter_ambient";
	level._effect["fx_zombie_mainframe_beam"] = "maps/zombie/fx_zombie_mainframe_beam";
	level._effect["fx_zombie_mainframe_flat"] = "maps/zombie/fx_zombie_mainframe_flat";
	level._effect["fx_zombie_mainframe_flat_start"] = "maps/zombie/fx_zombie_mainframe_flat_start";
	level._effect["fx_zombie_mainframe_beam_start"] = "maps/zombie/fx_zombie_mainframe_beam_start";
	level._effect["fx_zombie_flashback_theater"] = "maps/zombie/fx_zombie_flashback_theater";
	level._effect["fx_zombie_difference"] = "maps/zombie/fx_zombie_difference";
	level._effect["fx_zombie_heat_sink"] = "maps/zombie/fx_zombie_heat_sink";
	level._effect["fx_teleporter_pad_glow"] = "maps/zombie/fx_zombie_teleporter_pad_glow";
	level._effect["fx_portal"] = "maps/zombie/fx_zombie_portal_nix_num_pp";
	level._effect["zombie_packapunch"] = "maps/zombie/fx_zombie_packapunch";
	level._effect["boxlight_light_ready"] = "maps/zombie/fx_zombie_theater_lightboard_green";
	level._effect["boxlight_light_notready"] = "maps/zombie/fx_zombie_theater_lightboard_red";
	level._effect["fx_quad_roof_break"] = "maps/zombie/fx_zombie_crawler_roof_break";
	level._effect["fx_quad_roof_break_theater"] = "maps/zombie/fx_zombie_crawler_roof_theater";
	level._effect["fx_quad_dust_roof"] = "maps/zombie/fx_zombie_crawler_dust_roof";
}

