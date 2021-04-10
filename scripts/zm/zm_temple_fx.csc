// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\util_shared;

#namespace zm_temple_fx;

/*
	Name: main
	Namespace: zm_temple_fx
	Checksum: 0xDFA613F8
	Offset: 0x1948
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_util_fx();
	precache_createfx_fx();
	precache_creek_fx();
	disablefx = getdvarint("disable_fx");
	if(!isdefined(disablefx) || disablefx <= 0)
	{
		precache_scripted_fx();
	}
}

/*
	Name: precache_util_fx
	Namespace: zm_temple_fx
	Checksum: 0xC26523B8
	Offset: 0x19D8
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function precache_util_fx()
{
	level._effect["fx_trail_blood_streak"] = "trail/fx_trail_blood_streak";
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "dlc5/zmhd/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
}

/*
	Name: precache_scripted_fx
	Namespace: zm_temple_fx
	Checksum: 0x56D1D50A
	Offset: 0x1AA8
	Size: 0x18A
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["napalm_zombie_footstep"] = "dlc5/temple/fx_ztem_napalm_zombie_ground2";
	level._effect["punji_dust"] = "dlc5/temple/fx_ztem_dust_punji";
	level._effect["maze_wall_impact"] = "dlc5/temple/fx_ztem_dust_impact_maze";
	level._effect["maze_wall_raise"] = "dlc5/temple/fx_ztem_dust_maze_raise";
	level._effect["rag_doll_gib_mini"] = "maps/zombie_temple/fx_ztem_zombie_mini_squish";
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "dlc5/zmhd/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["perk_machine_light_yellow"] = "dlc5/zmhd/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc5/zmhd/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc5/zmhd/fx_wonder_fizz_light_green";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_temple_fx
	Checksum: 0x66F6EB8E
	Offset: 0x1C40
	Size: 0x96A
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
	level._effect["fx_ztem_power_sparks"] = "maps/zombie_temple/fx_ztem_power_sparks";
	level._effect["fx_elec_wire_spark_burst_xsm"] = "env/electrical/fx_elec_wire_spark_burst_xsm";
	level._effect["fx_ztem_dust_crumble_int_md_runner"] = "maps/zombie_temple/fx_ztem_dust_crumble_int_md_runner";
	level._effect["fx_ztem_ember_xsm"] = "maps/zombie_temple/fx_ztem_ember_xsm";
	level._effect["fx_ztem_dust_impact_maze"] = "dlc5/temple/fx_ztem_dust_maze_raise";
	level._effect["fx_ztem_torch"] = "maps/zombie_temple/fx_ztem_torch";
	level._effect["fx_ztem_cart_stop"] = "maps/zombie_temple/fx_ztem_cart_stop";
	level._effect["fx_mp_dlc4_roof_spill"] = "maps/mp_maps/fx_mp_dlc4_roof_spill";
	level._effect["fx_ztem_fountain_splash"] = "maps/zombie_temple/fx_ztem_fountain_splash";
	level._effect["fx_ztem_waterfall_distort"] = "maps/zombie_temple/fx_ztem_waterfall_distort";
	level._effect["fx_ztem_waterfall_bottom"] = "maps/zombie_temple/fx_ztem_waterfall_bottom";
	level._effect["fx_ztem_waterfall_b_bottom"] = "maps/zombie_temple/fx_ztem_waterfall_b_bottom";
	level._effect["fx_ztem_cave_wtr_sld_bttm"] = "maps/zombie_temple/fx_ztem_cave_wtr_sld_bttm";
	level._effect["fx_ztem_pap_warning"] = "maps/zombie_temple/fx_ztem_pap_warning";
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
	level._effect["fx_hot_sauce_trail"] = "dlc5/temple/fx_ztem_hot_sauce_trail";
	level._effect["fx_weak_sauce_trail"] = "dlc5/temple/fx_ztem_weak_sauce_trail";
	level._effect["fx_ztem_meteor_shrink"] = "maps/zombie_temple/fx_ztem_meteor_shrink";
	level._effect["fx_ztem_hot_sauce_end"] = "maps/zombie_temple/fx_ztem_hot_sauce_end";
	level._effect["fx_ztem_weak_sauce_end"] = "maps/zombie_temple/fx_ztem_weak_sauce_end";
	level._effect["fx_ztem_meteorite_trail_big"] = "maps/zombie_temple/fx_ztem_meteorite_trail_big";
	level._effect["fx_ztem_meteorite_tell"] = "maps/zombie_temple/fx_ztem_meteorite_tell";
	level._effect["fx_ztem_meteorite_shimmer"] = "maps/zombie_temple/fx_ztem_meteorite_shimmer";
	level._effect["fx_ztem_meteorite_small_shimmer"] = "maps/zombie_temple/fx_ztem_meteorite_small_shimmer";
	level._effect["fx_ztem_meteorite_big_shimmer"] = "maps/zombie_temple/fx_ztem_meteorite_big_shimmer";
	level._effect["fx_crystal_water_trail"] = "dlc5/temple/fx_ztem_meteorite_splash_run";
}

/*
	Name: precache_creek_fx
	Namespace: zm_temple_fx
	Checksum: 0x60BD856C
	Offset: 0x25B8
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function precache_creek_fx()
{
	level._effect["fx_insect_swarm_lg"] = "maps/creek/fx_insect_swarm_lg";
	level._effect["fx_ztem_smoke_thick_indoor"] = "maps/zombie_temple/fx_ztem_smoke_thick_indoor";
}

