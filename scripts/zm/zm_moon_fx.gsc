// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace zm_moon_fx;

/*
	Name: main
	Namespace: zm_moon_fx
	Checksum: 0xAD1C205C
	Offset: 0x10C0
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
	Namespace: zm_moon_fx
	Checksum: 0xC015E12E
	Offset: 0x1108
	Size: 0x382
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["large_ceiling_dust"] = "maps/zombie/fx_dust_ceiling_impact_lg_mdbrown";
	level._effect["poltergeist"] = "zombie/fx_barrier_buy_zmb";
	level._effect["gasfire"] = "destructibles/fx_dest_fire_vert";
	level._effect["switch_sparks"] = "dlc5/zmhd/fx_elec_wire_spark_burst";
	level._effect["wire_sparks_oneshot"] = "electrical/fx_elec_wire_spark_dl_oneshot";
	level._effect["rise_burst"] = "maps/zombie/fx_mp_zombie_hand_dirt_burst";
	level._effect["rise_billow"] = "maps/zombie/fx_mp_zombie_body_dirt_billowing";
	level._effect["rise_dust"] = "maps/zombie/fx_mp_zombie_body_dust_falling";
	level._effect["lght_marker"] = "dlc5/tomb/fx_tomb_marker";
	level._effect["lght_marker_flare"] = "dlc5/tomb/fx_tomb_marker_fl";
	level._effect["zapper_fx"] = "maps/zombie/fx_zombie_zapper_powerbox_on";
	level._effect["zapper"] = "maps/zombie/fx_zombie_electric_trap";
	level._effect["zapper_wall"] = "maps/zombie/fx_zombie_zapper_wall_control_on";
	level._effect["zapper_light_ready"] = "dlc5/zmhd/fx_zombie_zapper_light_green";
	level._effect["zapper_light_notready"] = "dlc5/zmhd/fx_zombie_zapper_light_red";
	level._effect["terminal_ready"] = "dlc5/moon/fx_moon_trap_switch_light_on_green";
	level._effect["elec_room_on"] = "maps/zombie/fx_zombie_light_elec_room_on";
	level._effect["elec_md"] = "electrical/fx_elec_player_md";
	level._effect["elec_sm"] = "electrical/fx_elec_player_sm";
	level._effect["elec_torso"] = "electrical/fx_elec_player_torso";
	level._effect["elec_trail_one_shot"] = "maps/zombie/fx_zombie_elec_trail_oneshot";
	level._effect["fx_quad_vent_break"] = "maps/zombie/fx_zombie_crawler_vent_break";
	level._effect["quad_grnd_dust_spwnr"] = "maps/zombie/fx_zombie_crawler_grnd_dust_spwnr";
	level._effect["jump_pad_jump"] = "dlc5/moon/fx_moon_jump_pad_pulse";
	level._effect["quad_phasing"] = "dlc5/moon/fx_zombie_phasing";
	level._effect["quad_phasing_in"] = "dlc5/moon/fx_quad_teleport_in";
	level._effect["quad_phasing_out"] = "dlc5/moon/fx_quad_teleport_out";
	level._effect["glass_impact"] = "dlc5/moon/fx_moon_break_window";
	level._effect["test_spin_fx"] = "env/light/fx_light_warning";
	level._effect["rocket_booster"] = "dlc5/moon/fx_earth_destroy_rocket";
	level._effect["blue_eyes"] = "maps/zombie/fx_zombie_eye_single_blue";
	level._effect["osc_button_glow"] = "dlc5/moon/fx_moon_button_console_glow";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_moon_fx
	Checksum: 0xC3236DF1
	Offset: 0x1498
	Size: 0x34A
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["fx_mp_fog_xsm_int"] = "maps/zombie_old/fx_mp_fog_xsm_int";
	level._effect["fx_moon_fog_spawn_closet"] = "maps/zombie_moon/fx_moon_fog_spawn_closet";
	level._effect["fx_zmb_fog_thick_300x300"] = "maps/zombie/fx_zmb_fog_thick_300x300";
	level._effect["fx_zmb_fog_thick_600x600"] = "maps/zombie/fx_zmb_fog_thick_600x600";
	level._effect["fx_moon_fog_canyon"] = "maps/zombie_moon/fx_moon_fog_canyon";
	level._effect["fx_moon_vent_wall_mist"] = "maps/zombie_moon/fx_moon_vent_wall_mist";
	level._effect["fx_dust_motes_blowing"] = "env/debris/fx_dust_motes_blowing";
	level._effect["fx_zmb_coast_sparks_int_runner"] = "maps/zombie/fx_zmb_coast_sparks_int_runner";
	level._effect["fx_moon_floodlight_narrow"] = "maps/zombie_moon/fx_moon_floodlight_narrow";
	level._effect["fx_moon_floodlight_wide"] = "maps/zombie_moon/fx_moon_floodlight_wide";
	level._effect["fx_moon_tube_light"] = "maps/zombie_moon/fx_moon_tube_light";
	level._effect["fx_moon_lamp_glow"] = "maps/zombie_moon/fx_moon_lamp_glow";
	level._effect["fx_moon_trap_switch_light_glow"] = "maps/zombie_moon/fx_moon_trap_switch_light_glow";
	level._effect["fx_moon_teleporter_beam"] = "maps/zombie_moon/fx_moon_teleporter_beam";
	level._effect["fx_moon_teleporter_start"] = "maps/zombie_moon/fx_moon_teleporter_start";
	level._effect["fx_moon_teleporter_pad_start"] = "maps/zombie_moon/fx_moon_teleporter_pad_start";
	level._effect["fx_moon_teleporter2_beam"] = "maps/zombie_moon/fx_moon_teleporter2_beam";
	level._effect["fx_moon_teleporter2_pad_start"] = "maps/zombie_moon/fx_moon_teleporter2_pad_start";
	level._effect["fx_moon_pyramid_egg"] = "maps/zombie_moon/fx_moon_pyramid_egg";
	level._effect["fx_moon_pyramid_drop"] = "maps/zombie_moon/fx_moon_pyramid_drop";
	level._effect["fx_moon_pyramid_opening"] = "maps/zombie_moon/fx_moon_pyramid_opening";
	level._effect["fx_moon_ceiling_cave_dust"] = "maps/zombie_moon/fx_moon_ceiling_cave_dust";
	level._effect["fx_moon_ceiling_cave_collapse"] = "maps/zombie_moon/fx_moon_ceiling_cave_collapse";
	level._effect["fx_moon_digger_dig_dust"] = "maps/zombie_moon/fx_moon_digger_dig_dust";
	level._effect["fx_moon_airlock_hatch_forcefield"] = "maps/zombie_moon/fx_moon_airlock_hatch_forcefield";
	level._effect["fx_moon_biodome_ceiling_breach"] = "maps/zombie_moon/fx_moon_biodome_ceiling_breach";
	level._effect["fx_moon_biodome_breach_dirt"] = "maps/zombie_moon/fx_moon_biodome_breach_dirt";
	level._effect["fx_moon_breach_debris_room_os"] = "maps/zombie_moon/fx_moon_breach_debris_room_os";
	level._effect["fx_moon_breach_debris_out_os"] = "maps/zombie_moon/fx_moon_breach_debris_out_os";
	level._effect["fx_earth_destroyed"] = "maps/zombie_moon/fx_earth_destroyed";
}

/*
	Name: fx_overrides
	Namespace: zm_moon_fx
	Checksum: 0x6D15C0F3
	Offset: 0x17F0
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

