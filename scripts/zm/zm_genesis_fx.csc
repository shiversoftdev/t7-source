// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_fx;

/*
	Name: main
	Namespace: zm_genesis_fx
	Checksum: 0xC28A92BD
	Offset: 0x12D8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_scripted_fx();
	precache_createfx_fx();
	callback::on_localclient_connect(&function_129a815f);
}

/*
	Name: precache_scripted_fx
	Namespace: zm_genesis_fx
	Checksum: 0xB2FAECFA
	Offset: 0x1328
	Size: 0x8DE
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["eye_glow"] = "dlc1/castle/fx_glow_eye_orange_castle";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["jugger_light"] = "dlc4/genesis/fx_perk_juggernaut";
	level._effect["revive_light"] = "dlc4/genesis/fx_perk_quick_revive";
	level._effect["sleight_light"] = "dlc4/genesis/fx_perk_sleight_of_hand";
	level._effect["doubletap2_light"] = "dlc4/genesis/fx_perk_doubletapa";
	level._effect["marathon_light"] = "dlc4/genesis/fx_perk_stamin_up";
	level._effect["additionalprimaryweapon_light"] = "dlc4/genesis/fx_perk_mule_kick";
	level._effect["shadowman_teleport"] = "zombie/fx_shdw_teleport_zod_zmb";
	level._effect["shadowman_hover_charge"] = "zombie/fx_shdw_glow_hover_charge_zod_zmb";
	level._effect["shadowman_energy_ball_charge"] = "zombie/fx_shdw_spell_charge_zod_zmb";
	level._effect["shadowman_energy_ball_explosion"] = "zombie/fx_shdw_spell_exp_zod_zmb";
	level._effect["shadowman_energy_ball"] = "zombie/fx_shdw_spell_zod_zmb";
	level._effect["shadowman_light"] = "light/fx_light_zod_shadowman_appear";
	level._effect["shadowman_smoke"] = "zombie/fx_shdw_floating_smk_zod_zmb";
	level._effect["shadowman_shield_glow_on"] = "dlc4/genesis/fx_bossbattle_shield_on";
	level._effect["shadowman_shield_glow_off"] = "dlc4/genesis/fx_bossbattle_shield_off";
	level._effect["zombie_soul_electricity"] = "dlc1/castle/fx_demon_zombie_death_energy";
	level._effect["zombie_soul_fire"] = "dlc1/castle/fx_rune_zombie_death_energy";
	level._effect["zombie_soul_light"] = "dlc1/castle/fx_storm_zombie_death_energy";
	level._effect["zombie_soul_shadow"] = "dlc1/castle/fx_wolf_zombie_death_energy";
	level._effect["smoke_geyser"] = "_debug/fx_missing_fx";
	level._effect["smoke_standard"] = "_debug/fx_missing_fx";
	level._effect["smoke_wall"] = "_debug/fx_missing_fx";
	level._effect["fire_ground_spotfire"] = "_debug/fx_missing_fx";
	level._effect["fire_ground_spotfire_smoke"] = "_debug/fx_missing_fx";
	level._effect["fire_moving_fire_trap"] = "_debug/fx_missing_fx";
	level._effect["fire_ignite_zombie"] = "_debug/fx_missing_fx";
	level._effect["flinger_launch"] = "dlc1/castle/fx_elec_jumppad";
	level._effect["flinger_land"] = "dlc1/castle/fx_dust_landingpad";
	level._effect["flinger_trail"] = "dlc1/castle/fx_elec_jumppad_player_trail";
	level._effect["launch_pad_cooldown"] = "dlc4/genesis/fx_jumppad_cooldown";
	level._effect["ee_toy_found"] = "light/fx_glow_orb_grow_tank_church_infection";
	level._effect["rq_gateworm_dissolve"] = "dlc4/genesis/fx_gateworm_dissolve";
	level._effect["rq_feeding_glow"] = "dlc1/zmb_weapon/fx_bow_rune_impact_ug_glow_zmb";
	level._effect["rq_rune_glow"] = "dlc4/genesis/fx_rune_glow_purple";
	level._effect["battery_uncharged"] = "dlc1/castle/fx_battery_elec_beam_castle";
	level._effect["battery_charged"] = "dlc1/castle/fx_battery_elec_beam_castle_2";
	level._effect["shadow_rq_chomper_light"] = "zombie/fx_trail_gem_white_doa";
	level._effect["corruption_engine_soul"] = "dlc4/genesis/fx_corrupteng_zombie_soul_115";
	level._effect["corruption_tower_active"] = "dlc4/genesis/fx_corrupteng_pillar_elec_blue";
	level._effect["corruption_tower_active_top"] = "dlc4/genesis/fx_corrupteng_pillar_elec_blue_top";
	level._effect["corruption_tower_active_top_ember"] = "dlc4/genesis/fx_corrupteng_pillar_ember_top";
	level._effect["corruption_tower_complete"] = "dlc4/genesis/fx_corrupteng_pillar_elec_red";
	level._effect["corruption_tower_complete_top"] = "dlc4/genesis/fx_corrupteng_pillar_elec_red_top";
	level._effect["corruption_tower_complete_top_ember"] = "dlc4/genesis/fx_corrupteng_pillar_ember_top_red";
	level._effect["sophia_transition"] = "dlc4/genesis/fx_sophia_elec_transition";
	level._effect["skull_eyes"] = "dlc4/genesis/fx_challenge_prizestone_skull_eyes_glow";
	level._effect["challenge_base"] = "dlc4/genesis/fx_challenge_prizestone_base_glow";
	level._effect["challenge_reward"] = "dlc4/genesis/fx_challenge_prizestone_base_open";
	level._effect["wisp_abcd"] = "dlc3/stalingrad/fx_voice_log_blue";
	level._effect["wisp_shad"] = "dlc4/genesis/fx_voice_log_red";
	level._effect["egg_spawn_fx"] = "dlc4/genesis/fx_egg_lowering_glow_trail";
	level._effect["low_grav_screen_fx"] = "dlc1/castle/fx_plyr_screen_115_liquid";
	level._effect["summoning_circle_fx"] = "dlc4/genesis/fx_summon_circle_rune_glow";
	level._effect["summoning_key_bubble"] = "zombie/fx_ee_shadowman_shield_loop_zod";
	level._effect["random_weapon_powerup_marker"] = "zombie/fx_weapon_box_marker_zmb";
	level._effect["arena_margwa_spawn"] = "dlc4/genesis/fx_margwa_spawn";
	level._effect["arena_tornado"] = "dlc4/genesis/fx_darkarena_shadow_tornado_loop";
	level._effect["arena_shadow_pillar"] = "dlc4/genesis/fx_darkarena_shadow_pillar_energy";
	level._effect["summoning_key_glow"] = "zombie/fx_ritual_glow_key_zod_zmb";
	level._effect["curse_tell"] = "dlc4/genesis/fx_summoningkey_basin_cooldown";
	level._effect["gateworm_basin_ready"] = "dlc4/genesis/fx_summoningkey_basin_fire_ready";
	level._effect["gateworm_basin_start"] = "dlc4/genesis/fx_summoningkey_basin_fire_start";
	level._effect["gateworm_basin_charging"] = "dlc4/genesis/fx_summoningkey_basin_charging";
	level._effect["rune_fire_eruption"] = "dlc4/genesis/fx_bow_rune_impact_ug_fire_genesis";
	level._effect["fire_column"] = "dlc4/genesis/fx_darkarena_column_fire";
	level._effect["elec_wall_tell"] = "dlc4/genesis/fx_darkarena_elec_wall_tell";
	level._effect["elec_wall_arc"] = "dlc4/genesis/fx_darkarena_elec_wall_arc_runner";
	level._effect["elec_wall_long_arc"] = "dlc4/genesis/fx_darkarena_elec_wall_long_arc_runner";
	level._effect["summoning_key_holder"] = "dlc4/genesis/fx_darkarena_key_holder_center";
	level._effect["summoning_key_charge_1"] = "dlc4/genesis/fx_darkarena_key_holder_01";
	level._effect["summoning_key_charge_2"] = "dlc4/genesis/fx_darkarena_key_holder_02";
	level._effect["summoning_key_charge_3"] = "dlc4/genesis/fx_darkarena_key_holder_03";
	level._effect["summoning_key_charge_4"] = "dlc4/genesis/fx_darkarena_key_holder_04";
	level._effect["dark_arena_podium"] = "dlc4/genesis/fx_darkarena_podium_unlocked";
	level._effect["mechz_ground_spawn"] = "dlc4/genesis/fx_mech_spawn";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_genesis_fx
	Checksum: 0x99EC1590
	Offset: 0x1C10
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
}

/*
	Name: function_129a815f
	Namespace: zm_genesis_fx
	Checksum: 0xD2E15CAD
	Offset: 0x1C20
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_129a815f(localclientnum)
{
}

/*
	Name: function_2c301fae
	Namespace: zm_genesis_fx
	Checksum: 0x37FBB8BC
	Offset: 0x1C38
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_2c301fae()
{
	level thread function_7eea24df();
}

/*
	Name: function_7eea24df
	Namespace: zm_genesis_fx
	Checksum: 0x483FF606
	Offset: 0x1C60
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function function_7eea24df()
{
	level._effect["chest_light_closed"] = "dlc4/genesis/fx_weapon_box_closed_glow_genesis";
	level._effect["chest_light"] = "dlc4/genesis/fx_weapon_box_open_glow_genesis";
}

