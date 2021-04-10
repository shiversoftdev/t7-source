// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace zm_temple_fx;

/*
	Name: main
	Namespace: zm_temple_fx
	Checksum: 0xE67DD354
	Offset: 0x1D48
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_util_fx();
	precache_scripted_fx();
	precache_createfx_fx();
	precache_creek_fx();
	level thread reset_water_burst_fx();
	level thread fx_overrides();
}

/*
	Name: precache_util_fx
	Namespace: zm_temple_fx
	Checksum: 0xDE8E0824
	Offset: 0x1DC8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function precache_util_fx()
{
	level._effect["animscript_gib_fx"] = "dlc5/zmhd/fx_flesh_gib_fatal_01";
	level._effect["fx_trail_blood_streak"] = "trail/fx_trail_blood_streak";
	level._effect["lght_marker"] = "dlc5/tomb/fx_tomb_marker";
	level._effect["lght_marker_flare"] = "dlc5/tomb/fx_tomb_marker_fl";
	level._effect["poltergeist"] = "dlc5/zmhd/fx_zombie_couch_effect";
	level._effect["large_ceiling_dust"] = "dlc5/zmhd/fx_dust_ceiling_impact_lg_mdbrown";
}

/*
	Name: precache_scripted_fx
	Namespace: zm_temple_fx
	Checksum: 0xBA506AEF
	Offset: 0x1E80
	Size: 0x26A
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["switch_sparks"] = "dlc5/zmhd/fx_elec_wire_spark_burst";
	level._effect["trap_light_ready"] = "misc/fx_zombie_zapper_light_green";
	level._effect["trap_light_notready"] = "misc/fx_zombie_zapper_light_red";
	level._effect["waterfall_trap"] = "env/water/fx_water_pipe_gush_lg";
	level._effect["geyser_ready"] = "env/water/fx_water_temple_geyser_ready";
	level._effect["geyser_active"] = "dlc5/temple/fx_water_pipe_spill_lg";
	level._effect["rise_burst_water"] = "maps/zombie/fx_mp_zombie_hand_water_burst";
	level._effect["rise_billow_water"] = "maps/zombie/fx_mp_zombie_body_water_billowing";
	level._effect["maze_wall_impact"] = "dlc5/temple/fx_ztem_dust_impact_maze";
	level._effect["fx_ztem_torch"] = "maps/zombie_temple/fx_ztem_torch";
	level._effect["fx_ztem_cart_stop"] = "maps/zombie_temple/fx_ztem_cart_stop";
	level._effect["fx_mp_dlc4_roof_spill"] = "maps/mp_maps/fx_mp_dlc4_roof_spill";
	level._effect["maze_wall_raise"] = "dlc5/temple/fx_ztem_dust_maze_raise";
	level._effect["barrier_break"] = "dlc5/temple/fx_ztem_dest_wood_barrier";
	level._effect["square_door_open"] = "maps/zombie_temple/fx_ztem_dust_door_square";
	level._effect["rolling_door_open"] = "dlc5/temple/fx_ztem_dust_door_round";
	level._effect["player_water_splash"] = "dlc5/temple/fx_water_splash_player";
	level._effect["player_land_dust"] = "dlc5/temple/fx_ztem_dust_player_impact";
	level._effect["napalm_zombie_footstep"] = "maps/zombie_temple/fx_ztem_napalm_zombie_ground2";
	level._effect["thundergun_knockdown_ground"] = "maps/zombie/fx_mp_zombie_hand_water_burst";
	level._effect["rag_doll_gib_mini"] = "maps/zombie_temple/fx_ztem_zombie_mini_squish";
	level._effect["corpse_gib"] = "dlc5/zmhd/fx_zombie_dog_explosion";
}

/*
	Name: reset_water_burst_fx
	Namespace: zm_temple_fx
	Checksum: 0x542D3BF
	Offset: 0x20F8
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function reset_water_burst_fx()
{
	wait(2);
	level._effect["rise_burst_water"] = "maps/zombie/fx_mp_zombie_hand_water_burst";
	level._effect["rise_billow_water"] = "maps/zombie/fx_mp_zombie_body_water_billowing";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_temple_fx
	Checksum: 0x867CD091
	Offset: 0x2148
	Size: 0x94E
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["fx_water_temple_geyser_ready"] = "env/water/fx_water_temple_geyser_ready";
	level._effect["fx_fire_md"] = "env/fire/fx_fire_md";
	level._effect["fx_fire_sm"] = "env/fire/fx_fire_sm";
	level._effect["fx_zombie_light_dust_motes_md"] = "maps/zombie/fx_zombie_light_dust_motes_md";
	level._effect["fx_mp_insects_lantern"] = "maps/zombie/fx_mp_insects_lantern";
	level._effect["fx_dust_crumble_int_md"] = "env/dirt/fx_dust_crumble_int_md";
	level._effect["fx_zmb_light_incandescent"] = "maps/zombie/fx_zmb_light_incandescent";
	level._effect["fx_ztem_drips"] = "maps/zombie_temple/fx_ztem_drips";
	level._effect["fx_ztem_waterfall_mist"] = "maps/zombie_temple/fx_ztem_waterfall_mist";
	level._effect["fx_ztem_waterfall_mist_trap"] = "maps/zombie_temple/fx_ztem_waterfall_mist_trap";
	level._effect["fx_ztem_leaves_falling"] = "maps/zombie_temple/fx_ztem_leaves_falling";
	level._effect["fx_ztem_leaves_falling_wide"] = "maps/zombie_temple/fx_ztem_leaves_falling_wide";
	level._effect["fx_ztem_dust_motes_blowing_lg"] = "maps/zombie_temple/fx_ztem_dust_motes_blowing_lg";
	level._effect["fx_ztem_butterflies"] = "maps/zombie_temple/fx_ztem_butterflies";
	level._effect["fx_ztem_tinhat_indoor"] = "maps/zombie_temple/fx_ztem_tinhat_indoor";
	level._effect["fx_ztem_godray_md"] = "maps/zombie_temple/fx_ztem_godray_md";
	level._effect["fx_ztem_fog_cave"] = "maps/zombie_temple/fx_ztem_fog_cave";
	level._effect["fx_ztem_fog_cave_lg"] = "maps/zombie_temple/fx_ztem_fog_cave_lg";
	level._effect["fx_ztem_fog_cave_drk"] = "maps/zombie_temple/fx_ztem_fog_cave_drk";
	level._effect["fx_ztem_fog_cave_drk2"] = "maps/zombie_temple/fx_ztem_fog_cave_drk2";
	level._effect["fx_ztem_spider"] = "maps/zombie_temple/fx_ztem_spider";
	level._effect["fx_ztem_birds"] = "maps/zombie_temple/fx_ztem_birds";
	level._effect["fx_ztem_fog_outdoor"] = "maps/zombie_temple/fx_ztem_fog_outdoor";
	level._effect["fx_ztem_fog_tunnels"] = "maps/zombie_temple/fx_ztem_fog_tunnels";
	level._effect["fx_ztem_fog_outdoor_lg"] = "maps/zombie_temple/fx_ztem_fog_outdoor_lg";
	level._effect["fx_ztem_power_on"] = "maps/zombie_temple/fx_ztem_power_on";
	level._effect["fx_ztem_power_onb"] = "maps/zombie_temple/fx_ztem_power_onb";
	level._effect["fx_ztem_dragonflies_lg"] = "maps/zombie_temple/fx_ztem_dragonflies_lg";
	level._effect["fx_slide_wake"] = "bio/player/fx_player_water_swim_wake";
	level._effect["fx_ztem_splash_3"] = "maps/zombie_temple/fx_ztem_splash_3";
	level._effect["fx_ztem_splash_4"] = "maps/zombie_temple/fx_ztem_splash_4";
	level._effect["fx_ztem_splash_exploder"] = "maps/zombie_temple/fx_ztem_splash_exploder";
	level._effect["fx_ztem_water_wake_exploder"] = "maps/zombie_temple/fx_ztem_water_wake_exploder";
	level._effect["fx_pow_cave_water_splash_sm"] = "maps/pow/fx_pow_cave_water_splash_sm";
	level._effect["fx_ztem_pap"] = "maps/zombie_temple/fx_ztem_pap";
	level._effect["fx_ztem_pap_splash"] = "maps/zombie_temple/fx_ztem_pap_splash";
	level._effect["fx_ztem_water_wake"] = "maps/zombie_temple/fx_ztem_water_wake";
	level._effect["fx_ztem_waterfall_body"] = "maps/zombie_temple/fx_ztem_waterfall_body";
	level._effect["fx_ztem_waterfall_body_b"] = "maps/zombie_temple/fx_ztem_waterfall_body_b";
	level._effect["fx_ztem_waterfall_trap"] = "maps/zombie_temple/fx_ztem_waterfall_trap";
	level._effect["fx_ztem_waterfall_notrap"] = "maps/zombie_temple/fx_ztem_waterfall_notrap";
	level._effect["fx_ztem_waterfall_trap_h"] = "maps/zombie_temple/fx_ztem_waterfall_trap_h";
	level._effect["fx_ztem_waterfall_drips"] = "maps/zombie_temple/fx_ztem_waterfall_drips";
	level._effect["fx_ztem_waterfall_low"] = "maps/zombie_temple/fx_ztem_waterfall_low";
	level._effect["fx_ztem_waterslide_splashes"] = "maps/zombie_temple/fx_ztem_waterslide_splashes";
	level._effect["fx_ztem_waterslide_splashes_wide"] = "maps/zombie_temple/fx_ztem_waterslide_splashes_wide";
	level._effect["fx_ztem_water_troff_power"] = "maps/zombie_temple/fx_ztem_water_troff_power";
	level._effect["fx_ztem_pap_stairs_splashes"] = "maps/zombie_temple/fx_ztem_pap_stairs_splashes";
	level._effect["fx_ztem_spikemore"] = "maps/zombie_temple/fx_ztem_spikemore";
	level._effect["fx_ztem_geyser"] = "dlc5/temple/fx_ztem_geyser";
	level._effect["fx_ztem_power_sparks"] = "maps/zombie_temple/fx_ztem_power_sparks";
	level._effect["fx_elec_wire_spark_burst_xsm"] = "env/electrical/fx_elec_wire_spark_burst_xsm";
	level._effect["fx_ztem_dust_impact_maze"] = "dlc5/temple/fx_ztem_dust_impact_maze";
	level._effect["fx_ztem_dust_crumble_int_md_runner"] = "maps/zombie_temple/fx_ztem_dust_crumble_int_md_runner";
	level._effect["fx_ztem_ember_xsm"] = "maps/zombie_temple/fx_ztem_ember_xsm";
	level._effect["fx_ztem_dust_door_round"] = "dlc5/temple/fx_ztem_dust_door_round";
	level._effect["fx_ztem_fountain_splash"] = "maps/zombie_temple/fx_ztem_fountain_splash";
	level._effect["fx_ztem_waterfall_distort"] = "maps/zombie_temple/fx_ztem_waterfall_distort";
	level._effect["fx_ztem_waterfall_bottom"] = "maps/zombie_temple/fx_ztem_waterfall_bottom";
	level._effect["fx_ztem_waterfall_b_bottom"] = "maps/zombie_temple/fx_ztem_waterfall_b_bottom";
	level._effect["fx_ztem_cave_wtr_sld_bttm"] = "maps/zombie_temple/fx_ztem_cave_wtr_sld_bttm";
	level._effect["fx_ztem_pap_warning"] = "maps/zombie_temple/fx_ztem_pap_warning";
	level._effect["fx_ztem_dest_wood_barrier"] = "maps/zombie_temple/fx_ztem_dest_wood_barrier";
	level._effect["fx_ztem_fireflies"] = "maps/zombie_temple/fx_ztem_fireflies";
	level._effect["fx_ztem_tunnel_water_gush"] = "maps/zombie_temple/fx_ztem_tunnel_water_gush";
	level._effect["fx_ztem_tunnel_water_splash"] = "maps/zombie_temple/fx_ztem_tunnel_water_splash";
	level._effect["fx_ztem_leak_gas_jet"] = "maps/zombie_temple/fx_ztem_leak_gas_jet";
	level._effect["fx_ztem_leak_flame_jet_runner"] = "maps/zombie_temple/fx_ztem_leak_flame_jet_runner";
	level._effect["fx_ztem_leak_water_jet_runner"] = "maps/zombie_temple/fx_ztem_leak_water_jet_runner";
	level._effect["fx_ztem_moon_eclipse"] = "maps/zombie_temple/fx_ztem_moon_eclipse";
	level._effect["fx_ztem_star_shooting_runner"] = "maps/zombie_temple/fx_ztem_star_shooting_runner";
	level._effect["fx_ztem_crystal_hit_success"] = "maps/zombie_temple/fx_ztem_crystal_hit_success";
	level._effect["fx_ztem_crystal_hit_fail"] = "maps/zombie_temple/fx_ztem_crystal_hit_fail";
	level._effect["fx_ztem_crystal_pause_success"] = "maps/zombie_temple/fx_ztem_crystal_pause_success";
	level._effect["fx_ztem_crystal_pause_fail"] = "maps/zombie_temple/fx_ztem_crystal_pause_fail";
	level._effect["fx_hot_sauce_trail"] = "maps/zombie_temple/fx_ztem_hot_sauce_trail";
	level._effect["fx_ztem_meteor_shrink"] = "maps/zombie_temple/fx_ztem_meteor_shrink";
	level._effect["fx_ztem_hot_sauce_end"] = "maps/zombie_temple/fx_ztem_hot_sauce_end";
	level._effect["fx_ztem_weak_sauce_end"] = "maps/zombie_temple/fx_ztem_weak_sauce_end";
	level._effect["fx_ztem_meteorite_trail_big"] = "maps/zombie_temple/fx_ztem_meteorite_trail_big";
	level._effect["fx_ztem_meteorite_tell"] = "maps/zombie_temple/fx_ztem_meteorite_tell";
	level._effect["fx_ztem_meteorite_shimmer"] = "maps/zombie_temple/fx_ztem_meteorite_shimmer";
	level._effect["fx_ztem_meteorite_small_shimmer"] = "maps/zombie_temple/fx_ztem_meteorite_small_shimmer";
	level._effect["fx_ztem_meteorite_big_shimmer"] = "maps/zombie_temple/fx_ztem_meteorite_big_shimmer";
	level._effect["rise_dust_water"] = "maps/zombie/fx_zombie_body_wtr_falling";
}

/*
	Name: precache_creek_fx
	Namespace: zm_temple_fx
	Checksum: 0xDC6B7C6C
	Offset: 0x2AA0
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function precache_creek_fx()
{
	level._effect["fx_insect_swarm_lg"] = "maps/creek/fx_insect_swarm_lg";
	level._effect["fx_ztem_smoke_thick_indoor"] = "maps/zombie_temple/fx_ztem_smoke_thick_indoor";
}

/*
	Name: fx_overrides
	Namespace: zm_temple_fx
	Checksum: 0x75D86964
	Offset: 0x2AE8
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
	level._effect["additionalprimaryweapon_light"] = "dlc5/temple/fx_perk_mule_kick";
	level._effect["deadshot_light"] = "dlc5/zmhd/fx_perk_daiquiri";
	level._effect["marathon_light"] = "dlc5/zmhd/fx_perk_stamin_up";
	level._effect["widow_light"] = "dlc5/zmhd/fx_perk_widows_wine";
}

