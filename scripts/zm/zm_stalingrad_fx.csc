// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace zm_stalingrad_fx;

/*
	Name: init
	Namespace: zm_stalingrad_fx
	Checksum: 0xF930F3AA
	Offset: 0x880
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function init()
{
	precache_scripted_fx();
}

/*
	Name: precache_scripted_fx
	Namespace: zm_stalingrad_fx
	Checksum: 0xE46F271A
	Offset: 0x8A0
	Size: 0x39E
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["zapper"] = "dlc3/stalingrad/fx_elec_trap_stalingrad";
	level._effect["dragon_fire_burn_tell"] = "dlc3/stalingrad/fx_player_screen_fire_embers_hazard";
	level._effect["pavlov_lockdown_light"] = "dlc3/stalingrad/fx_light_emergency_flash_loop_stalingrad";
	level._effect["dragon_egg_heat"] = "dlc3/stalingrad/fx_dragon_gauntlet_egg_heat";
	level._effect["drop_pod_hp_light_green"] = "dlc3/stalingrad/fx_drop_pod_health_light_green";
	level._effect["drop_pod_hp_light_yellow"] = "dlc3/stalingrad/fx_drop_pod_health_light_yellow";
	level._effect["drop_pod_hp_light_red"] = "dlc3/stalingrad/fx_drop_pod_health_light_red";
	level._effect["jugger_light"] = "dlc3/stalingrad/fx_perk_juggernaut_sta";
	level._effect["doubletap2_light"] = "dlc3/stalingrad/fx_perk_doubletap_sta";
	level._effect["additionalprimaryweapon_light"] = "dlc3/stalingrad/fx_perk_mule_kick_sta";
	level._effect["revive_light"] = "dlc3/stalingrad/fx_perk_quick_revive_sta";
	level._effect["sleight_light"] = "dlc3/stalingrad/fx_perk_sleight_of_hand_sta";
	level._effect["marathon_light"] = "dlc3/stalingrad/fx_perk_stamin_up_sta";
	level._effect["generic_explosion"] = "explosions/fx_exp_grenade_default";
	level._effect["ambient_mortar_small"] = "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_sm_os";
	level._effect["ambient_mortar_medium"] = "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_os";
	level._effect["ambient_mortar_large"] = "dlc3/stalingrad/fx_exp_mortar_stalingrad_exp_lg_os";
	level._effect["ambient_artillery_small"] = "dlc3/stalingrad/fx_exp_artillery_sm";
	level._effect["ambient_artillery_medium"] = "dlc3/stalingrad/fx_exp_artillery_md";
	level._effect["ambient_artillery_large"] = "dlc3/stalingrad/fx_exp_artillery_lg";
	level._effect["transport_eject"] = "dlc3/stalingrad/fx_dragon_transport_saddle_jump";
	level._effect["dragon_tongue"] = "dlc3/stalingrad/fx_dragon_mouth_drips_tongue_boss";
	level._effect["dragon_mouth"] = "dlc3/stalingrad/fx_dragon_mouth_drips_boss";
	level._effect["dragon_eye_l"] = "dlc3/stalingrad/fx_dragon_glow_eye_L";
	level._effect["dragon_eye_r"] = "dlc3/stalingrad/fx_dragon_glow_eye_R";
	level._effect["dragon_wound_hit"] = "dlc3/stalingrad/fx_dragon_hit_lava";
	level._effect["nikolai_weakpoint_fx"] = "dlc3/stalingrad/fx_mech_vdest_heat_vent_tell";
	level._effect["nikolai_weakpoint_destroyed"] = "dlc3/stalingrad/fx_mech_vdest_heat_vent_loop";
	level._effect["nikolai_gatling_tell"] = "dlc3/stalingrad/fx_mech_wpn_cannon_tell";
	level._effect["nikolai_harpoon_impact"] = "dlc3/stalingrad/fx_mech_wpn_harpoon_ground_impact";
	level._effect["nikolai_raps_trail"] = "vehicle/fx_nikolai_raps_trail_small";
	level._effect["nikolai_raps_landing"] = "dlc3/stalingrad/fx_mech_wpn_raps_landing";
	level._effect["audio_log"] = "dlc3/stalingrad/fx_voice_log_blue";
}

